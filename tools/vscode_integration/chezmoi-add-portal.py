#!/usr/bin/env python

import os
import subprocess
import sys
import uuid
from urllib.parse import unquote, urlparse

import gi

gi.require_version("Gio", "2.0")
from gi.repository import Gio, GLib  # noqa: E402


PORTAL_BUS_NAME = "org.freedesktop.portal.Desktop"
PORTAL_OBJECT_PATH = "/org/freedesktop/portal/desktop"


def file_uri_to_path(uri: str) -> str:
    parsed = urlparse(uri)
    if parsed.scheme != "file" or parsed.netloc not in ("", "localhost"):
        raise ValueError(f"Unsupported URI returned by the file picker: {uri}")
    return unquote(parsed.path)


def choose_files() -> list[str]:
    bus = Gio.bus_get_sync(Gio.BusType.SESSION, None)
    sender = bus.get_unique_name().removeprefix(":").replace(".", "_")
    token = f"chezmoi_{uuid.uuid4().hex}"
    request_path = f"/org/freedesktop/portal/desktop/request/{sender}/{token}"

    result: dict[str, object] = {}
    loop = GLib.MainLoop()

    def on_response(_bus, _sender, _path, _interface, _signal, parameters):
        response, options = parameters.unpack()
        result["response"] = response
        result["uris"] = options.get("uris", [])
        loop.quit()

    subscription = bus.signal_subscribe(
        PORTAL_BUS_NAME,
        "org.freedesktop.portal.Request",
        "Response",
        request_path,
        None,
        Gio.DBusSignalFlags.NONE,
        on_response,
    )

    options = {
        "handle_token": GLib.Variant("s", token),
        "multiple": GLib.Variant("b", True),
        "current_folder": GLib.Variant("ay", os.fsencode(os.path.expanduser("~")) + b"\0"),
    }

    try:
        reply = bus.call_sync(
            PORTAL_BUS_NAME,
            PORTAL_OBJECT_PATH,
            "org.freedesktop.portal.FileChooser",
            "OpenFile",
            GLib.Variant("(ssa{sv})", ("", "Add files to chezmoi", options)),
            GLib.VariantType("(o)"),
            Gio.DBusCallFlags.NONE,
            -1,
            None,
        )
        returned_path = reply.unpack()[0]
        if returned_path != request_path:
            raise RuntimeError(
                f"Portal returned an unexpected request path: {returned_path}"
            )
        loop.run()
    finally:
        bus.signal_unsubscribe(subscription)

    response = result.get("response")
    if response == 1:  # The user cancelled the dialog.
        return []
    if response != 0:
        raise RuntimeError(f"The file picker failed with response code {response}")

    return [file_uri_to_path(uri) for uri in result.get("uris", [])]


def main() -> int:
    try:
        paths = choose_files()
    except Exception as error:
        print(f"Could not open the system file picker: {error}", file=sys.stderr)
        return 1

    if not paths:
        return 0

    return subprocess.run(["chezmoi", "add", "--", *paths], check=False).returncode


if __name__ == "__main__":
    raise SystemExit(main())

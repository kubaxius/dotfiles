# Steam HiDPI workaround

Steam's desktop UI currently ignores its documented fractional-scaling
options. Hyprland's `xwayland.force_zero_scaling` keeps the window sharp, but
that leaves Steam's Chromium UI at 1x.

`steam-scale-shim.c` intercepts CEF initialization and then calls CEF's own
device-scale setter. The chezmoi `run_onchange` script compiles it locally to
`~/.local/lib/libsteamscale.so`; no downloaded binary or Steam-managed file is
modified.

Launch Steam from the application menu or run `steam-scaled`. The default
factor is 1.5. To test another factor, fully exit Steam and run, for example:

```sh
STEAM_SCALE_FACTOR=1.75 steam-scaled
```

Steam strips `XCURSOR_*` variables when it relaunches itself inside its runtime.
The shim therefore restores `XCURSOR_SIZE=16` before CEF starts, which keeps the
cursor reasonably sized after applying the UI scale.

TODO: Make Steam use the system Breeze cursor theme. Steam's Chromium runtime
currently ignores the configured theme and renders a different, blurry cursor.
Setting `XCURSOR_THEME`/`XCURSOR_PATH`, publishing the values through Xresources,
and copying Breeze into the per-user icon path did not fix the theme lookup.

If a future Steam update restores scaling, switch the desktop entry back to
`/usr/bin/steam` and remove this workaround.

The implementation is based on the MIT-licensed
[steam-hidpi-shim](https://github.com/katerinakosac51-creator/steam-hidpi-shim).

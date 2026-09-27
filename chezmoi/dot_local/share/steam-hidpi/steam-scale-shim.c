/*
 * Force a fractional device scale for Steam's CEF desktop UI.
 *
 * Steam's May 2026 client stopped applying its documented Linux desktop
 * scaling overrides.  Steam still exports the CEF scale setter, so this shim
 * calls it immediately after CEF has initialized.
 *
 * Based on the MIT-licensed steam-hidpi-shim by katerinakosac51-creator:
 * https://github.com/katerinakosac51-creator/steam-hidpi-shim
 */

#define _GNU_SOURCE

#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define DEFAULT_SCALE 1.5
#define DEFAULT_CURSOR_SIZE "16"

typedef int (*cef_initialize_fn)(const void *, const void *, void *, void *);
typedef void (*cef_set_scale_fn)(double);

static void configure_cursor_size(void) {
	/* Steam's self-relaunch strips the launcher's XCURSOR_* variables. */
	setenv("XCURSOR_SIZE", DEFAULT_CURSOR_SIZE, 1);
}

__attribute__((constructor))
static void configure_steamwebhelper_cursor(void) {
	char executable[4096];
	const char *name;
	ssize_t length;

	length = readlink("/proc/self/exe", executable, sizeof(executable) - 1);
	if (length < 0) {
		return;
	}
	executable[length] = '\0';
	name = strrchr(executable, '/');
	name = name == NULL ? executable : name + 1;

	if (strcmp(name, "steamwebhelper") == 0) {
		configure_cursor_size();
	}
}

static double requested_scale(void) {
	const char *value = getenv("STEAM_SCALE_FACTOR");
	char *end = NULL;
	double scale;

	if (value == NULL || *value == '\0') {
		return DEFAULT_SCALE;
	}

	scale = strtod(value, &end);
	if (end == value || *end != '\0' || scale < 0.1 || scale > 10.0) {
		fprintf(stderr,
			"steam-scale: invalid STEAM_SCALE_FACTOR=%s; using %.2f\n",
			value, DEFAULT_SCALE);
		return DEFAULT_SCALE;
	}

	return scale;
}

int cef_initialize(const void *args, const void *settings, void *application,
		   void *windows_sandbox_info) {
	static cef_initialize_fn real_initialize;
	cef_set_scale_fn set_scale;
	int result;

	if (real_initialize == NULL) {
		real_initialize = (cef_initialize_fn)dlsym(RTLD_NEXT, "cef_initialize");
	}
	if (real_initialize == NULL) {
		fprintf(stderr, "steam-scale: could not resolve cef_initialize\n");
		return 0;
	}

	result = real_initialize(args, settings, application, windows_sandbox_info);
	if (!result) {
		return result;
	}

	set_scale = (cef_set_scale_fn)dlsym(
		RTLD_NEXT, "cef_set_force_device_scale_factor");
	if (set_scale == NULL) {
		fprintf(stderr,
			"steam-scale: Steam's CEF scale API is unavailable; "
			"continuing without an override\n");
		return result;
	}

	set_scale(requested_scale());
	return result;
}

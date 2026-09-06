# XDG base directories

Which application state is allowed to sit in `$HOME`, and how it is moved out.

<a id="prefer-xdg-directories"></a>
## `xdg.nix` — one switch, not per-module overrides

**Why** `home.preferXdgDirectories` relocates every home-manager module that
supports it from one line; here that is `readline`, `gtk2` and `lazygit`. Each
of those also has a hand-settable variable — `INPUTRC`, `GTK2_RC_FILES`,
`LAZYGIT_NEW_DIR_FILE` — and setting one is strictly worse, because
home-manager keeps writing the old path.
**Breaks** *Silently.* An `INPUTRC` set in `xdg-app-dirs.nix` would point
readline at a file nothing generates, discarding every setting in `shell/bash.nix`'s
`programs.readline` with no error and no missing file.
**Also** `xdg.enable` is what exports the four `XDG_*_HOME` variables, into
`systemd.user.sessionVariables` as well as the login shell. `wallpaper/service.nix`
depends on the systemd half for its `%C` specifier.

## `xdg-app-dirs.nix` — `dev`, not `core`

**Why** Rust, Gradle, Android, .NET, npm, Go, PostgreSQL, AWS and Docker are
toolchain state, and `gpc` takes neither the toolchains nor `dev`. It is the
same test `dev/ccache.nix` already passes, in the same aspect. `XCOMPOSECACHE`
is not a toolchain, so it is the one variable in that file declaring `core`.

<a id="android-user-home"></a>
## `ANDROID_USER_HOME` — the AVD `.ini` carries an absolute `path=`

**Why** An AVD is described by a pair of files: `avd/<name>.ini` holds both
`path=` (absolute) and `path.rel=` (relative to `ANDROID_USER_HOME`), and the
absolute one wins.
**Breaks** The emulator, on the *next* machine-image move rather than at
switch: relocating the directory without rewriting `path=` in each `.ini`
leaves Android Studio pointing at a directory that no longer exists, and the
AVD list comes up empty. There is nothing to regenerate it from.

<a id="android-emulator-home"></a>
## `ANDROID_EMULATOR_HOME` — the emulator has never read `ANDROID_USER_HOME`

**Why** The emulator launcher resolves its user directory from
`ANDROID_EMULATOR_HOME`, then `ANDROID_PREFS_ROOT`, then `ANDROID_SDK_HOME`,
then `~/.android`; `strings` over the `emulator` binary finds each of those
and not `ANDROID_USER_HOME`. Relocating the latter alone left
`emu-update-last-check.ini`, the feature-flag protobuf and `modem-nv-ram-*`
landing in `~/.android` on every launch. Both variables name the same
directory, so the CLI and the emulator read one tree.
**Breaks** *Outside the dev shell.* AVDs are searched under
`$ANDROID_EMULATOR_HOME/avd` unless `ANDROID_AVD_HOME` overrides it, and only
the template's `enterShell` sets that override. Drop this variable and an
emulator started anywhere else — Android Studio from a desktop entry — looks
in `~/.android/avd` and reports `Unknown AVD name` for a device the CLI lists.
**Also** `ANDROID_HOME` sits beside it: the emulator, Gradle and the CLI all
read it, its default is `~/Android/Sdk`, and the SDK already lives under
`$ANDROID_USER_HOME/sdk` — the variable names where it is rather than moving it.

<a id="screenshots-user-dir"></a>
## `screenshot.nix` — `SCREENSHOTS` is a user-dirs entry, not a variable

**Why** `XDG_SCREENSHOTS_DIR` is grimblast's extension to the user-dirs spec,
not part of it, and grimblast sources `user-dirs.dirs` itself before reading the
variable — so `xdg.userDirs.extraConfig` reaches it without exporting anything,
which is what `setSessionVariables = false` asks for. The value is derived from
`xdg.userDirs.pictures`, so shots land under the pictures directory rather than
in a third top-level directory of their own, and `createDirectories` makes it.
**Breaks** *Quietly, one shot at a time.* Delete the entry and grimblast falls
back to `XDG_PICTURES_DIR`, dropping shots loose in `~/Pictures`. Spelling the
key `XDG_SCREENSHOTS_DIR` still works but warns — home-manager normalises the
long form only below stateVersion 26.05.
**Also** it was a `home.sessionVariables` line in `hosts/generator.nix` pointing
at `~/Screenshots`; the wiring never had a reason to know where a screenshot
goes.

## What stays in `$HOME`

`.mozilla`, `.floorp`, `.pki`, `.icons`, `.cmake`, `.lldb`, `.omnisharp`,
`.java`, `.gemini`, `.cursor`, `.android`, `.emulator_console_auth_token`,
`.dotnet/corefx`, `.aws/cli`, `.aws/sso`.

**Why** None of them honours a variable, and the alternatives cost more than
the tidiness is worth — a `HOME`-rewriting wrapper per binary, or
`_JAVA_OPTIONS` for `.java`, which prints a banner to stderr on every JVM
start. `.android` is now only adb's key pair: adb reads `HOME` and no
`ANDROID_*` directory variable. The console token path is a literal in the
emulator, and `.dotnet/corefx` is the runtime's X.509 store, which
`DOTNET_CLI_HOME` does not reach. awscli joins `~` to `.aws/cli/cache` and
`.aws/sso/cache` in source; only its two files and the login cache take a
variable. gdb needs nothing: history saving is off and its default file is
`./.gdb_history`, not `$HOME`.
**Also** listed here so the question is answered rather than re-opened.

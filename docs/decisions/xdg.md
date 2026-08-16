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
readline at a file nothing generates, discarding every setting in `bash.nix`'s
`programs.readline` with no error and no missing file.
**Also** `xdg.enable` is what exports the four `XDG_*_HOME` variables, into
`systemd.user.sessionVariables` as well as the login shell. `hyprpaper-service.nix`
depends on the systemd half for its `%C` specifier.

## `xdg-app-dirs.nix` — `dev`, not `core`

**Why** Rust, Gradle, Android, .NET, npm and Docker are toolchain state, and
`gpc` takes neither the toolchains nor `dev`. It is the same test `dev/ccache.nix`
already passes, in the same aspect. `XCOMPOSECACHE` is not a toolchain, so it
is the one variable in that file declaring `core`.

<a id="android-user-home"></a>
## `ANDROID_USER_HOME` — the AVD `.ini` carries an absolute `path=`

**Why** An AVD is described by a pair of files: `avd/<name>.ini` holds both
`path=` (absolute) and `path.rel=` (relative to `ANDROID_USER_HOME`), and the
absolute one wins.
**Breaks** The emulator, on the *next* machine-image move rather than at
switch: relocating the directory without rewriting `path=` in each `.ini`
leaves Android Studio pointing at a directory that no longer exists, and the
AVD list comes up empty. There is nothing to regenerate it from.

## What stays in `$HOME`

`.mozilla`, `.floorp`, `.pki`, `.icons`, `.cmake`, `.lldb`, `.omnisharp`,
`.java`, `.gemini`, `.cursor`.

**Why** None of them honours a variable, and the alternatives cost more than
the tidiness is worth — a `HOME`-rewriting wrapper per binary, or
`_JAVA_OPTIONS` for `.java`, which prints a banner to stderr on every JVM
start.
**Also** listed here so the question is answered rather than re-opened.

# Placement

Which aspect a file belongs to, and why it is not the obvious one.

## `window-tags.nix` — `core`, not `hyprland`

The file that installs an app describes its windows, and must not acquire a
dependency on a compositor to do it. A host whose session reads nothing carries
the value inertly — swift5 builds byte-identical.

## `mime.nix` — associations live with the aspect that installs

An association for a program this aspect does not install is a dead default.
What is left here is `core`'s own.

## `discord.nix` — `equibop.desktop`

equibop ships `equibop.desktop`; the association still named `vesktop.desktop`,
which nothing here installs.

## `laptop.nix` — deliberately small

power-profiles-daemon and upower stay in `core` because the bar's battery
widget runs on the desktops too. A too-small aspect is recoverable where a
broken power path is not.

<a id="unfree-home"></a>
## `editor/claude-code.nix`, `gaming/launchers.nix`, `nvidia/nvtop.nix` — `homeManager`, unfree included

**Why** User apps default to `homeManager` (AGENTS.md §6), and unfree is no
bar: `unfree.nix` sets `nixpkgs.config.allowUnfree` in **both classes**, and
standalone Home Manager honours the home-module option — its `misc/nixpkgs.nix`
re-imports `pkgs.path` with it and injects the result as `pkgs`. An earlier
entry here recorded the opposite ("accepted and then ignored"); that was wrong
for the pinned home-manager, and `verify.sh` measured the grant itself as a
six-target no-op — `allowUnfree` gates evaluation, not derivations. The unfree
reach is real: `lutris` pulls unfree `pkgs.steam` through `steamSupport ? true`;
`nvtopPackages.nvidia` pulls `cuda_nvml_dev` under the CUDA EULA.
**Breaks** Loudly on the licence if `unfree.nix` loses its `homeManager.core`
half — the nixos half does not reach the standalone home build. `steam` itself
stays `nixos`: `programs.steam` has no home-manager side (32-bit GL, firewall).

## `unfree.nix` — `core`, not `gaming`

Not a gaming fact, and one file for both classes. It was only ever in gpc's
host file because that is where the first unfree package happened to be needed.

## `brightnessctl.nix` — two audiences, neither `core`

Hyprland binds and hypridle call it by bare name, so it must be on PATH wherever
that session runs; on a laptop it is a tool reached for directly. dwl needs
neither entry — it interpolates the store path into compiled config, and
`dwl-idle` carries it in its own `runtimeInputs`.

## `clipboard.nix` — compositor-agnostic

Both sessions bind a clipboard-history key, and the picker renders through the
same menu program as the launcher — so the aspect providing one provides the
other.

## `launcher/wmenu.nix` — theming belongs to neither intent

Two intents render through wmenu (launcher and clipboard picker), so its theming
is an option both read. Both hold the store path, so wmenu is on PATH only for
the human.

## `launcher/elephant.nix` — named explicitly

Walker's data-provider backend, with its own daemon and config tree that
`wallpaper/picker.nix` writes into. The walker flake's module enabled it
implicitly; the home-manager module does not.

## `hyprland/hyprland.nix` — the GTK portal

File choosers and settings. dwl declares its portals on the nixos side via
`xdg.portal.extraPortals`.

## `hyprland/screenshot.nix` — follows the session

Bound to keys in `hyprland/binds.nix`, so it follows the session rather than the
app set. dwl builds its own ocr-copy against its own keybind.

## `editor/neovim.nix` / `editor/neovide.nix` — the toolchain follows `dev`

**Why** The two upstream builds differ by an LSP toolchain, not by a feature
flag: `full` carries ~6.0 GiB of store paths `min` does not — kotlin-lsp,
clang/llvm, the dotnet SDK, a JDK, basedpyright. `core` therefore installs
`min`, the notepad every host needs, through `editor.package`; `dev` sets that
option to `full`. A host that does not develop does not pay for a language
server it cannot invoke.
**Also** Neovide is `dev` for the same reason and not because it is a GUI:
it drives `neovim.gui`, whose closure is that toolchain again — measured at 7
paths over `full`, so free beside it and the whole 6.4 GiB without it.

<a id="man-pager-colours"></a>
## `cli/man.nix` — the pager colours are `home.sessionVariables`

**Why** `LESS_TERMCAP_*` and `GROFF_NO_SGR` are exported variables no shell
interprets, so re-emitting them from each shell's rc would be duplication with a
drift risk. They sat in `shell/bash.nix` because the hex → `r;g;b` helper did;
`desktop.colorsRgb` ended that. Coverage is equal or better: bash reaches
`hm-session-vars.sh` through `~/.profile`, which `xsession-wrapper` also sources
before any session; zsh sources it from `~/.zshenv` and `~/.zprofile`.
**Breaks** Nothing here. The cost is that `GROFF_NO_SGR=1` is session-wide
rather than per-interactive-bash, reaching any groff call — nothing here makes
one but `man`.
**Also** Nix has no `\e`: `"\e"` is the letter, and so is `''\e`. The byte comes from
`builtins.fromJSON` on a `\u001b` escape. Scheme adapted from
<https://gist.github.com/bahamas10/542875bb47990933638d2b7dfaa501bf>.

## Small ones

- `git/git.nix` — the GitHub CLI is system-wide because it was; only its home changed.
- `home-manager.nix` — the CLI belongs with the module;
  `home-manager switch` is how a host is driven.
- `dev/ccache.nix` — ccache plus the CMake launcher env, for
  out-of-nix C/C++ builds.

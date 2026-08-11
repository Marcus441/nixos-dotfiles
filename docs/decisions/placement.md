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

power-profiles-daemon and upower stay in `core` because waybar's battery module
runs on the desktops too. A too-small aspect is recoverable where a broken power
path is not.

## `unfree.nix` — `core`, not `gaming`

Not a gaming fact. It was only ever in gpc's host file because that is where the
first unfree package happened to be needed.

## `brightnessctl.nix` — two audiences, neither `core`

Hyprland binds and hypridle call it by bare name, so it must be on PATH wherever
that session runs; on a laptop it is a tool reached for directly. dwl needs
neither entry — it interpolates the store path into compiled config, and
`dwl-idle` carries it in its own `runtimeInputs`.

## `clipboard.nix` — compositor-agnostic

Both sessions bind a clipboard-history key, and the picker renders through the
same menu program as the launcher — so the aspect providing one provides the
other.

## `wmenu.nix` — theming belongs to neither intent

Two intents render through wmenu (launcher and clipboard picker), so its theming
is an option both read. Both hold the store path, so wmenu is on PATH only for
the human.

## `elephant.nix` — named explicitly

Walker's data-provider backend, with its own daemon and config tree that
`hyprpaper-picker.nix` writes into. The walker flake's module enabled it
implicitly; the home-manager module does not.

## `hyprland.nix` — the GTK portal

File choosers and settings. dwl declares its portals on the nixos side via
`xdg.portal.extraPortals`.

## `hyprland-screenshot.nix` — follows the session

Bound to keys in `hyprland-binds.nix`, so it follows the session rather than the
app set. dwl builds its own ocr-copy against its own keybind.

## `neovim.nix` / `neovide.nix` — headless vs GUI

`neovim.nix` is `core` and provides the headless `nvim` both profiles share;
Neovide is the GUI front-end and is `apps` only.

<a id="man-pager-colours"></a>
## `man.nix` — the pager colours are `home.sessionVariables`

`LESS_TERMCAP_*` and `GROFF_NO_SGR` are exported variables that no shell
interprets, so re-emitting them from each shell's rc would be duplication with a
drift risk and nothing to show for it. They sat in `bash.nix` because the hex →
`r;g;b` helper did; `desktop.colorsRgb` ended that.

Coverage is equal or better than the `.bashrc` they left. bash reaches
`hm-session-vars.sh` through `~/.profile`, which nixpkgs' `xsession-wrapper`
also sources before launching any session, so every terminal inherits them; zsh
sources it from `~/.zshenv` for non-login shells and `~/.zprofile` for login
ones. The cost is that `GROFF_NO_SGR=1` is now session-wide rather than
per-interactive-bash, which reaches any groff call. Nothing here makes one but
`man`.

Nix has no `\e`: `"\e"` is the letter, and so is `''\e`. The byte comes from
`builtins.fromJSON` on a `\u001b` escape. Home Manager writes each variable as
`export NAME="value"`, where a literal ESC is fine.

Scheme adapted from
<https://gist.github.com/bahamas10/542875bb47990933638d2b7dfaa501bf>.

## Small ones

- `git.nix` — the GitHub CLI is system-wide because it was; only its home changed.
- `home-manager.nix` — the CLI belongs with the module;
  `home-manager switch` is how a host is driven.
- `ccache.nix` — ccache plus the CMake launcher env, for
  out-of-nix C/C++ builds.

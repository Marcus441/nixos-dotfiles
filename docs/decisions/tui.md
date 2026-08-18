# TUIs and file managers

The programs that have to carry a terminal with them, the two file managers, and
the multiplexer the rest of them sit inside. The terminals themselves are in
`terminal.md`.

## `filemanager/yazi.nix` — the program is `apps`, the role is its own aspect

**Why** So a host can install yazi without making it what `$mod+E` opens.
**Breaks** `thunar` and `yazi` both set `fileManager.command`, so taking both is
a conflict naming both files.

<a id="yazi-requires"></a>
## `filemanager/yazi.nix` — `aspectRequires.yazi = ["apps"]`

**Why** `finalPackage` is declared outside `mkIf cfg.enable`.
**Breaks** *Silently.* Without it, a host taking `yazi` without `apps` gets an
unconfigured `pkgs.yazi` rather than an error.

<a id="yazi-command"></a>
## `filemanager/yazi.nix` — the command is bound, not read back

**Why** Composed at argv level and rendered once — `transientCommand` is already
escaped, so appending would escape twice.
**Breaks** *Silently.* Reading back through `config.fileManager.command` means a
`mkForce` elsewhere wins, and an entry named "Yazi" execs thunar.

<a id="desktop-exec"></a>
## `filemanager/yazi.nix` — a desktop `Exec` is not shell-escaped

**Why** `Exec` is parsed by the desktop-entry spec, not a shell, and `'` is
reserved there. `lib.escapeShellArgs` quotes any argument outside
`[a-zA-Z0-9,._+:@%/-]`, so the moment one contains `=` — ghostty's
`--class=term.floating` — it emits quotes the spec forbids. The same argv is
therefore rendered twice.
**Breaks** Loudly, at build time: `desktop-file-validate` refuses the entry. It
went unnoticed while every terminal's argv happened to need no quoting.

<a id="yazi-reset"></a>
## `filemanager/yazi-style.nix` — `mode._alt.bg` is `base00`, not `reset`

**Why** `status.lua` reads that background back as a *foreground*:
`ui.Span(sep_left.close):fg(style.alt:bg())`.
**Breaks** *Silently.* A `reset` there is the default text colour — a base05 bar
through the middle of the bar. base00 is the terminal background, so it renders
as nothing.

<a id="yazi-frames"></a>
## `filemanager/yazi-style.nix` — `base01` is the surface, `base02` the selection

**Why** The editor's floats put each block's border in that block's own
background, so the frame reads as padding rather than an outline. The whole
theme runs on two values: `base01` is every ambient surface — the seven borders,
the filled popups, the bar under an unfocused pane's hovered row — and `base02`,
base24's selection slot, is reserved for the one thing actually selected.
**Breaks** *Silently.* The preset sets `reversed = true` on
`indicator.parent`/`current`, `cmp.active`, `input.selected` and `help.hovered`,
and a partial theme merges onto it — so a `bg` set without an explicit
`reversed = false` is swapped into the foreground and paints the text, not the
row.
**Also** `base10` was tried for the parent and preview bars first, and reads as
a hole rather than a highlight.

<a id="yazi-blocks"></a>
## `filemanager/yazi-style.nix` — `input` and `cmp` fill, and the rest cannot

**Why** Every yazi popup draws ratatui's `Clear` — so `Cell::EMPTY`, the
terminal default — then an *unstyled* `Block`, so no key fills an interior
directly. Two fill anyway because their contents cover every cell: `input` is
three rows and `border` + `title` + `value` reach all of them, and `cmp` sizes
its area to `items.len() + 2`. That is why they are solid where `confirm`,
`tasks`, `spot` and `notify` are frames.
**Breaks** Nothing loudly — a popup that cannot fill stays on the terminal
background. Do not generalise from either half; check which keys reach which
cells.
**Also** `confirm` is *nearly* fillable through `body` and `list`, but its
button row leaves gaps; a half-filled popup reads worse than an unfilled one.

<a id="thunar-daemon"></a>
## `filemanager/thunar.nix` — the drop-in adds `[Install]` and no `ExecStart`

**Why** thunar ships `thunar.service` with no `[Install]`, so systemd starts it
lazily and the first window pays the startup cost.
**Breaks** NixOS merges this as a drop-in *over* the packaged unit, and a second
`ExecStart=` on a non-oneshot service makes systemd refuse to load it.

## `filemanager/thunar.nix` — the directory association moved out of `core`

**Why** The default followed the option.
**Breaks** `core` used to point every host at `thunar.desktop`, including the
one with no thunar installed.

<a id="btop-views"></a>
## `cli/btop.nix` — a view is a whole config file, not a `--preset`

**Why** A preset chooses boxes and nothing else, but each readout wants its own
`proc_sorting` and `proc_tree` — config keys with no flag behind them. So the
three views are three generated configs passed to `--config`, and `shown_boxes`
states the layout by name rather than by an index into a `presets` string. The
bare `systemMonitor.command` stays outside the views: the overlay's header
click gets a plain btop reading the interactive config.
**Breaks** `save_config_on_exit` defaults to true and these paths are in the
store, so each view turns it off; without that btop tries to write a read-only
file on quit. The same read-only-ness is why a setting changed inside a
row-opened btop is gone at exit — by design, and only there. `programs.btop.settings`
is the interactive config and keeps the tree.

<a id="impala-argv"></a>
## `network/impala.nix` — impala over NetworkManager's iwd

**Why** `network/net.nix` runs NetworkManager with `wifi.backend = "iwd"`, so both talk
to the same daemon.
**Breaks** A connection impala makes is one NetworkManager did not author, so
NM's state can disagree until it resyncs.
**Also** the spawn is `compactArgv`, not `transientArgv`. Every bar click lands
in the same `1200 760` float, so the font was the only thing making impala a
different terminal from btop's three.

<a id="impala-darkgray"></a>
## `network/impala.nix` — every `DarkGray` background is repainted, and one is not

**Why** impala has a config file and it carries keybindings only; every colour
is a ratatui constant. `DarkGray` is ANSI 8, which in this palette is the
*light* neutral `#a6a69c` (`theming.md#colors-neutrals`), so a selected row
drew `#c5c9c5` on it at 1.4:1 and a passphrase field the same. The 71
background uses become base02 where the style is a selection and base01
everywhere else — the split `#yazi-frames` already draws.
**Breaks** The 72nd use is a *foreground*, the dimmed rows for unavailable
known networks, where `#a6a69c` is the right answer. That is why the match is
on `bg(` and not on the colour alone. `--replace-fail` aborts the build when a
version bump moves the pattern, which is the only notice that the patch has
gone stale.

<a id="herdr-bare-names"></a>
## `herdr.nix` — the two helpers herdr spawns by bare name

**Why** herdr is compiled and reaches its helpers by name, so each has to be on
the profile: `python3` for the `SessionStart` hook that
`herdr integration install claude` writes, and `notify-send` for
`ui.toast.delivery = "system"`. Neither was here. python3Minimal is enough —
the hook imports only `json`, `os`, `random`, `socket` and `time` — and
libnotify is what carries notify-send. Everything else in this tree holds
libnotify by store path, which is the preference in
`conventions/placement.md`; herdr cannot, so the corollary there applies and
the package goes on PATH.
**Breaks** *Silently, and the python half already had.* The hook guards on
`command -v python3 || exit 0` so a missing interpreter never blocks a session
from starting: a 182 KiB herdr-server.log held zero `report_agent_session`
calls, and herdr had never once learned which pane held a Claude session. A
missing notify-send drops every system toast the same quiet way. Both read as
a herdr bug rather than as a missing package.
**Also** the hook script carries "managed by herdr; reinstalling or updating
the integration overwrites this file", so it is herdr's to write and must stay
undeclared. Only the dependencies are ours.

<a id="herdr-theme-tokens"></a>
## `herdr.nix` — eleven tokens over a base theme, not a palette

**Why** `[theme.custom]` overrides individual tokens on top of a built-in
theme rather than defining one, and the accepted set is in neither herdr's docs
nor its config template. Read off `herdr config check`, which names every key
it rejects: `panel_bg`, `surface_dim`, `text`, `accent`, `blue`, `teal`,
`green`, `yellow`, `peach`, `red` and `mauve`. The seven hues land exactly on
base08–base0E, so only the two surfaces are a judgement — the panel takes
base00 to sit flush with the terminal, and the raised surface takes base01, the
same split `#yazi-frames` draws. `kanagawa` is the base because the palette is
Kanagawa Dragon, so the tokens left unset are already close.
**Breaks** A key outside that set is reported by `herdr config check` and then
ignored, leaving one colour at the base theme's value with nothing failing.
The set is not stable API — re-check it after a version bump.

## `herdr.nix` — declaring the config retires `herdr update`

**Why** `settings` renders `config.toml` into the store and symlinks it
read-only, which disables the two commands that write it back:
`herdr config reset-keys` and `herdr channel set`. Both exist to serve
`herdr update`, and that is the wrong way to move a version the flake pins.
**Breaks** Nothing in normal use; loudly if either command is reached for.
Custom keybindings belong in `settings.keys`, where a reinstall cannot revert
them.

## `editor/claude-code.nix` — the package, not `programs.claude-code`

**Why** Not the licence — unfree is fine in `home.packages` now
(`placement.md#unfree-home`) — but the module's `settings` would install
`settings.json` mode 444 and symlink it, and two writers need that file
mutable. Claude Code's own `/config` writes `model`, `theme` and `tui` from
inside the running app, and `herdr integration install claude` injects its
`SessionStart` hook there.
**Breaks** *Silently, then in the wrong place.* Declaring those settings means
the next `herdr integration install claude` cannot write its hook;
`herdr integration status` reports claude missing, and nothing in that message
points at Nix.

# TUIs and file managers

The programs that have to carry a terminal with them, and the two file managers.
The terminals themselves are in `terminal.md`.

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

<a id="btop-presets"></a>
## `cli/btop.nix` — the two presets exist so `--preset` can mean something

**Why** btop has no flag for "start on the memory view". Preset 0 is its
built-in all-boxes layout and config presets are numbered from 1, so the string
defines 1 = processor + processes and 2 = memory + processes — the two states
the bar's readouts click into.
**Breaks** Reordering or shortening the string re-points `systemMonitor.command`
and `systemMonitor.memoryCommand` at whatever now sits at that index, silently.

<a id="impala-argv"></a>
## `impala.nix` — impala over NetworkManager's iwd

**Why** `net.nix` runs NetworkManager with `wifi.backend = "iwd"`, so both talk
to the same daemon.
**Breaks** A connection impala makes is one NetworkManager did not author, so
NM's state can disagree until it resyncs.

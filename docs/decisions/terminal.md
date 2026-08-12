# Terminal and TUIs

The four terminals, the namespace they implement, and the programs that have to
carry one with them.

<a id="terminal-namespace"></a>
## `terminal.nix` — the namespace is a file of its own, naming no terminal

**Why** foot, alacritty, ghostty and kitty genuinely compete for `terminal.*`,
which is the same reason `launcher.nix` exists apart from wmenu and walker. The
`hyprland` setter lives here too, and stays terminal-agnostic by going through
`appIdArgv` — one file, two aspects, the `lock.nix` shape.
**Breaks** Left in `foot.nix`, that setter fires for *any* Hyprland host and
appends foot's `--app-id` to whatever terminal the host actually took.

<a id="terminal-desktopfile"></a>
## `terminal.nix` — `desktopFile` and `binary` carry no default

**Why** They are the only scalars in the namespace. Every other member is a
list or a function, and both of those **merge by concatenating** rather than
conflicting — two terminal aspects would silently produce
`argv = ["…/footclient" "…/kitty"]` and run one as the other's argument.
**Breaks** Without them nothing rejects a host taking two terminals; the
generator cannot help, because `aspectRequires` says "needs" and never
"excludes". A scalar with no default gives the conflict `fileManager.command`
already gives thunar-plus-yazi, naming both files. A host taking *no* terminal
gets `terminal.argv has no value defined` — loud, but it does not name the
missing aspect.

<a id="terminal-daemons"></a>
## `terminal/*.nix` — all four keep a server, each with a different client

**Why** Opening a window should cost nothing. Each terminal offers that
differently, and the aspect owns both halves:

| | server | client |
| --- | --- | --- |
| foot | `foot --server` | `footclient` |
| alacritty | `alacritty --daemon` | `alacritty msg create-window` |
| kitty | `kitty --single-instance --start-as=hidden` | `kitty --single-instance` |
| ghostty | `ghostty --gtk-single-instance=true --initial-window=false` | `ghostty` |

Every server is wired **twice**, because the sessions start things differently
(`sessions.md#dwl-autostart`): a systemd user unit for Hyprland, and a
`dwl.autostart` entry — a bare name from `~/.nix-profile/bin`, no `'` — for dwl.
**Breaks** A client is useless when its server is down, which is exactly when
you want a terminal, so `fallbackArgv` is a role of its own and both sessions
bind it. Wire only one channel and the terminal is slow on the other session
with nothing to say why.
**Also** foot's and alacritty's servers hold no window at all; kitty's is
headless by `--start-as=hidden`; ghostty's uses `--initial-window=false`.

<a id="kitty-single-instance"></a>
## `terminal/kitty.nix` — the client's argv crosses the socket, but not all of it

**Why** kitty's client ships its whole argv over and the server parses it fresh
— `boss.py`'s single-instance handler runs `parse_args` on the incoming
`data['args']`, then `create_opts`, then `create_sessions`. What that handler
then *uses* is a short list: `wclass` (so `--class term.floating` works and a
TUI floats), `wname`, `title`, and `opts_for_size`, plus two explicit
per-window special cases for `background_opacity` and `background_image`.
**Breaks** *Silently, for everything not on that list.* **`-o font_size` is not
on it** — the new window renders in the running instance's font, because the
whole point of single-instance is that instances "share a single sprite cache
on the GPU". Anything that must differ per spawn has to be checked against that
handler, not assumed from `--class` working.

<a id="kitty-compact-group"></a>
## `terminal/kitty.nix` — compact spawns get their own instance group

**Why** `compactArgv` shrinks the font so a 24-row TUI fits the floating window,
and by the entry above a single-instance client cannot change the font.
`--instance-group=compact` makes those spawns a *second* kitty instance, created
by the first of them and so built at `compactSize`; the rest join it and stay
cheap. The alternative — dropping `--single-instance` for compact spawns — works
too but pays full startup on every btop click.
**Breaks** Measured on foot, not kitty: `compactSize` is three fifths of the host
font size because that is where **foot's** cell metrics put 24 rows in
`1200 600`. kitty's differ, so verify with
`kitty --instance-group=probe -o font_size=12 bash -c 'sleep 1; stty size'`
and raise the fraction, or the floating window, if the first number is under 24.

<a id="ghostty-single-instance"></a>
## `terminal/ghostty.nix` — the server serves the plain bind only

**Why** `gtk-single-instance` defaults to `detect`, which switches itself
**off** when `TERM_PROGRAM` is set or when *any* CLI argument is present,
because "single instance mode inherits the configuration from when it was
launched" (`ghostty.5`). Setting it `true` explicitly is what makes
`SUPER+Return` reuse the running process.
**Breaks** Nothing, and that is worth stating: `-e` independently forces
`gtk-single-instance=false`, and every TUI spawn site appends `terminal.exec`,
which is `["-e"]` here. So a transient spawn always forks — slower than the
other three, by ghostty's design — but it also always honours its own
`--class`, which a connecting client would have silently ignored. The two rules
cancel; remove either and floating TUIs stop floating.

<a id="ghostty-enablement"></a>
## `terminal/ghostty.nix` — the unit's `[Install]` symlink is declared by hand

**Why** Home Manager writes ghostty's unit through `xdg.configFile` rather than
`systemd.user.services`, so nothing emits the `graphical-session.target.wants`
symlink that a `[Install]` section would otherwise produce.
**Breaks** *Quietly, and only in the first second.* Ghostty's D-Bus service file
carries `SystemdService=`, so the first launch activates the unit anyway and
every later one is fast — the symptom is not a broken terminal but the first
window of every session paying for the server.

<a id="ghostty-resident"></a>
## `terminal/ghostty.nix` — `quit-after-last-window-closed` is false

**Why** The config ghostty was revived from set it `true` with a `10m` delay.
A server that exits ten minutes after the last window is not a server, and
systemd will not bring it back: the packaged unit is `Type=notify-reload`, so a
clean exit is success.
**Breaks** *Silently, and only after a pause.* Everything is fast until the
first ten idle minutes, after which the next terminal pays full startup and the
session has no server again until the next login.

<a id="terminal-transient"></a>
## `terminal.nix` — `transientArgv` is named for the lifecycle

**Why** A TUI you open, act in, and close. dwl tiles it, Hyprland floats it, so
neither answer belongs in the name.
**Breaks** Naming it `floatingArgv` would make a spawn point assert a window
behaviour dwl rejects.

<a id="terminal-exec"></a>
## `terminal.nix` — `exec` sits between the options and the command

**Why** foot and kitty take a bare trailing command; alacritty and ghostty need
`-e`, and alacritty needs it *last*. A spawn point composing
`transientArgv ++ [prog]` is therefore only correct for half the terminals, and
`exec` is the piece that names the difference.
**Breaks** *Silently, on ghostty.* An argument it does not recognise as a
command is dropped and a plain shell opens instead. It cannot live inside
`argv`, because `compactArgv` appends a font override after `transientArgv` and
that would land past the `-e`.

<a id="terminal-ansi"></a>
## `theme/colors.nix` — the ANSI table is upstream's, and the index is the slot

**Why** kanagawa.nvim ships the dragon terminal theme for all four of these
terminals, generated from one table — `themes.lua`'s `dragon.term`. That table
is the authority, so `desktop.ansi` reproduces it exactly rather than deriving
it from a slot convention. Written out per terminal it would appear four times
in four vocabularies — `regular0`, `colors.normal.black`, `color0`,
`palette = "0=…"` — so it is one ordered list and each terminal renders it by
index.
**Breaks** *Silently.* Anything reading a colour by number is off by a slot, and
reordering the list reassigns every colour at once — the same trap qt5ct's
positional role list carries.
**Also** the earlier shape read `colors16` and duplicated slots 1–6 into 9–14,
on the argument that a TUI asking for "the base16 theme" asserts ANSI 9 is
base09. Nothing in this tree reads a colour by slot number — bat, yazi, tmux,
opencode, zsh, lazygit, man and prompt all take hex or a tmTheme — so that
argument bought nothing and cost every bright: ANSI 8 sat at 2.9:1 on the
background and 9–14 were byte-identical to 1–6, which the unconfigured
consumers (fzf, git, ls) are the ones that felt.
**Also** slots 16 and 17 are **not** in the list. They are the 256-cube trick
that is the only way base09 and base0F reach a terminal at all, so each
implementation reads `colors16` for those directly, as it does for foreground,
background and selection.
**Also** the cursor is base05 — the foreground — in all four, and the colour
under it is base00. Every default here is a different colour: foot and alacritty
reverse foreground and background, and kitty's `cursor_text_color` is a bare
`#111111` rather than the background it sits on. foot's `cursor` takes both
values in one string and alacritty's takes both keys, so the text colour is
spelled out three times rather than left to the terminal.

<a id="terminal-clipboard-keys"></a>
## `terminal/*.nix` — the dedicated copy/cut/paste keys, and who already had them

**Why** a keyboard sending `KC_COPY`/`KC_CUT`/`KC_PASTE` produces the keysyms
`XF86Copy`/`XF86Cut`/`XF86Paste`, and three of the four terminals already bind
two of the three: foot ships `XF86Copy`/`XF86Paste` as defaults of
`clipboard-copy`/`clipboard-paste`, ghostty ships `copy` and `paste`, and
alacritty ships `Copy` and `Paste`. Only kitty binds none, which is why it is
the one file listing all three.
**Breaks** *Silently, in foot.* A `[key-bindings]` value **replaces** the
default combos rather than adding to them, so `clipboard-copy` has to restate
`Control+Shift+c` and `XF86Copy` alongside the `XF86Cut` it exists to add —
dropping either kills a binding that was working before the line was written.
**Also** no terminal has a cut, so the cut key is a copy that does nothing
without a selection: kitty's `copy_or_noop`, alacritty's `Copy`, and ghostty's
`copy_to_clipboard`, which is *performable* and so falls through as if unbound.
kitty's `copy_and_clear_or_interrupt` was the other candidate and was rejected:
with no selection it sends SIGINT, so a stray press would kill a running
command.

<a id="kitty-borders"></a>
## `terminal/kitty.nix` — the split borders are ours, not upstream's

**Why** kanagawa.nvim's `extras/kitty/kanagawa_dragon.conf` sets no border
colours, so `enabled_layouts = "splits,stack"` drew kitty's stock
`active_border_color #00ff00`, `inactive_border_color #cccccc` and
`bell_border_color #ff5a00` — the one part of the terminal the theme could not
reach. They take base0D/base03/base08, the same roles `hyprland-general.nix`
gives a window border, because a kitty split is the same thing one level down.
**Breaks** *Loudly, but only in a split.* A single window never shows a border,
so this survived every look at the colours until someone opened a split.
**Also** upstream specifies nothing here, so these three are the only terminal
colours in the tree that a diff against `extras/` cannot check.

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

**Why** `Exec` is parsed by the desktop-entry spec, not by a shell, and `'` is
reserved there. `lib.escapeShellArgs` quotes any argument outside
`[a-zA-Z0-9,._+:@%/-]`, so the moment one contains `=` — ghostty's
`--class=term.floating` — it emits single quotes the spec forbids. The same argv
is therefore rendered twice: shell-escaped for `fileManager.command`, and
double-quoted-where-needed for the entry.
**Breaks** Loudly, at build time: `desktop-file-validate` refuses the entry with
"contains a reserved character `'` outside of a quote". It went unnoticed while
every terminal's argv happened to need no quoting at all.

<a id="ghostty-shader"></a>
## `terminal/ghostty.nix` — the cursor shader, and what kitty does instead

**Why** ghostty is the only one of the four that runs a custom fragment shader,
so `cursor_smear.glsl` is interpolated to a store path rather than a source
path — `pkgs.formats.keyValue` takes atoms, not paths. kitty refuses custom
shaders as a matter of policy; its `cursor_trail` is the same effect by a
different mechanism, cell-aware and idle when the cursor is still, where
ghostty's `custom-shader-animation` redraws every frame a window is open.
**Breaks** *Silently.* A shader that fails to compile is ignored and says so
only in the log. The power asymmetry matters if either aspect ever lands on
`swift5`.

<a id="ghostty-scrollback"></a>
## `terminal/ghostty.nix` — `scrollback-limit` is bytes, and stays unset

**Why** Every other terminal here counts lines. ghostty counts **bytes**, and
its default is 10 MB; the config this file was revived from carried
`scrollback-limit = 50000`, which reads like foot's 10 000 lines and is in fact
50 KB.
**Breaks** *Silently.* Roughly a hundredth of the intended scrollback, with
nothing to indicate the unit was misread.

<a id="kitty-font-option"></a>
## `terminal/kitty.nix` — the font comes from `programs.kitty.font`, not `settings`

**Why** Home Manager emits `font` at `mkOrder 510` and `settings` at 540, so
`settings.font_size` would be written second and shadow the option.
**Breaks** *Silently, in the wrong direction* — the value that loses is the one
declared in the obvious place.

<a id="kitty-cursor-trail"></a>
## `terminal/kitty.nix` — `wheel_scroll_multiplier` is not ghostty's number

**Why** ghostty's `mouse-scroll-multiplier = 0.95` scales its own default.
kitty's `wheel_scroll_multiplier` defaults to `5.0` and is *lines per event*, so
copying 0.95 across would ask for less than one line per notch.
**Breaks** Scrolling that feels broken rather than tuned. The general rule for
this pair: the settings are analogous, the units are not.

<a id="yazi-reset"></a>
## `filemanager/yazi.nix` — `mode._alt.bg` is `base00`, not `reset`

**Why** `status.lua` reads that background back as a *foreground*:
`ui.Span(sep_left.close):fg(style.alt:bg())`.
**Breaks** *Silently.* A `reset` there is the default text colour — a base05 bar
through the middle of the bar. base00 is the terminal background, so it
renders as nothing.

<a id="terminal-compact"></a>
## `terminal.nix` — `compactSize` is three fifths of the host font size

**Why** Measured on UM790pro, against Hyprland's `floating-size` rule of
`1200 600`: 20pt gives 17x88, 14pt gives 24x126, 12pt gives 28x148. btop refuses
to start under 24x60, so the full size misses it by seven rows and 14pt clears
it with none to spare. Three fifths lands on 12pt there. The *measurement* is
shared; the flag that carries it is not, because foot's override re-renders the
whole font spec — family and ligature suppression included — where the other
three take a bare number.
**Breaks** btop exits with "Terminal size too small" rather than opening. Any
change to `floating-size`, to a host's `fontSize`, or to this fraction moves the
row count — measure with `footclient -o main.font=... bash -c 'sleep 1; stty size'`.
Write `font.size * 3 / 5` with the spaces: `3/5` is a path literal.

<a id="terminal-appid"></a>
## `terminal.nix` — `appIdArgv` is a function, not a flag name

**Why** The four spellings differ in shape, not just in text: foot takes
`--app-id <id>`, alacritty and kitty `--class <id>`, and ghostty accepts
**only** `--class=<id>`.
**Breaks** *Silently.* ghostty given the space form swallows it with no
diagnostic at all, so a `flag` string plus `[flag id]` would leave ghostty
windows unnamed and every floating TUI tiled.

<a id="terminal-alt-scroll"></a>
## `terminal/foot.nix` — `alternate-scroll-mode` is foot's alone

**Why** It stops the wheel sending arrow keys in the alternate screen, so
scrolling a full-screen TUI scrolls the terminal instead of walking shell
history.
**Breaks** *Silently, on three hosts out of four.* alacritty, kitty and ghostty
have no equivalent setting, so the fix is foot-only and choosing another
terminal quietly reverts it.

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

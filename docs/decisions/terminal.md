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

<a id="foot-server"></a>
## `terminal/foot.nix` — daemon mode, and why every spawn point keeps a fallback

**Why** Terminals spawn as `footclient` against a foot server. uwsm activates
the unit on Hyprland; the dwl session is a plain script and starts the server
from `dwl.autostart`.
**Breaks** footclient is useless if the server is down — exactly when you want a
terminal. The plain-`foot` fallback is a role of its own, which is why
`fallbackArgv` exists at all; for a terminal with no daemon it defaults back to
`argv` and the fallback bind is merely redundant.

<a id="terminal-transient"></a>
## `terminal.nix` — `transientArgv` is named for the lifecycle

**Why** A TUI you open, act in, and close. dwl tiles it, Hyprland floats it, so
neither answer belongs in the name.
**Breaks** Naming it `floatingArgv` would make a spawn point assert a window
behaviour dwl rejects.

<a id="terminal-exec"></a>
## `foot.nix` — `exec` sits between the options and the command

**Why** foot and kitty take a bare trailing command; alacritty and ghostty need
`-e`, and alacritty needs it *last*. A spawn point composing
`transientArgv ++ [prog]` is therefore only correct for half the terminals, and
`exec` is the piece that names the difference.
**Breaks** *Silently, on ghostty.* An argument it does not recognise as a
command is dropped and a plain shell opens instead. It cannot live inside
`argv`, because `compactArgv` appends a font override after `transientArgv` and
that would land past the `-e`.

<a id="terminal-ansi"></a>
## `theme/colors.nix` — the base16 slot mapping is a list, and the index is the slot

**Why** A TUI asking for "the base16 theme" asserts ANSI 9 is base09. The
brights used to come from base12–base17, so that assertion was false. With four
terminals the mapping would be written four times in four vocabularies —
`regular0`, `colors.normal.black`, `color0`, `palette = "0=…"` — so it is one
ordered list in `desktop.ansi` and each terminal renders it by index.
**Breaks** *Silently.* Anything reading a colour by number is off by a slot, and
reordering the list reassigns every colour at once — the same trap qt5ct's
positional role list carries. The cost is that regular and bright differ only in
slots 0 and 7.
**Also** slots 16 and 17 are **not** in the list. They are the 256-cube trick
that is the only way base09 and base0F reach a terminal at all, so each
implementation reads `colors16` for those directly, as it does for foreground,
background and selection.

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
through the middle of the bar. base00 is foot's terminal background, so it
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

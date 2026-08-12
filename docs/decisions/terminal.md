# Terminal and TUIs

foot, and the programs that have to carry a terminal with them.

<a id="foot-server"></a>
## `foot.nix` — daemon mode, and why every spawn point keeps a fallback

**Why** Terminals spawn as `footclient` against a foot server. uwsm activates
the unit on Hyprland; the dwl session is a plain script and starts the server
from its own autostart.
**Breaks** footclient is useless if the server is down — exactly when you want a
terminal. The plain-`foot` fallback is a role of its own.

<a id="foot-transient"></a>
## `foot.nix` — `transientArgv` is named for the lifecycle

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

<a id="yazi-reset"></a>
## `filemanager/yazi.nix` — `mode._alt.bg` is `base00`, not `reset`

**Why** `status.lua` reads that background back as a *foreground*:
`ui.Span(sep_left.close):fg(style.alt:bg())`.
**Breaks** *Silently.* A `reset` there is the default text colour — a base05 bar
through the middle of the bar. base00 is foot's terminal background, so it
renders as nothing.

<a id="foot-compact"></a>
## `foot.nix` — `compactArgv` is three fifths of the host font size

**Why** Measured on UM790pro, against Hyprland's `floating-size` rule of
`1200 600`: 20pt gives 17x88, 14pt gives 24x126, 12pt gives 28x148. btop refuses
to start under 24x60, so the full size misses it by seven rows and 14pt clears
it with none to spare. Three fifths lands on 12pt there.
**Breaks** btop exits with "Terminal size too small" rather than opening. Any
change to `floating-size`, to a host's `fontSize`, or to this fraction moves the
row count — measure with `footclient -o main.font=... bash -c 'sleep 1; stty size'`.

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

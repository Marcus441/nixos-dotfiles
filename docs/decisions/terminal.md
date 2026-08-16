# Terminals

The four terminals and the namespace they implement. The TUIs and file managers
that have to carry one are in `tui.md`.

<a id="terminal-namespace"></a>
## `terminal/terminal.nix` — the namespace is a file of its own, naming no terminal

**Why** Four terminals compete for `terminal.*`, the same reason `launcher/launcher.nix`
sits apart from wmenu and walker. The `hyprland` setter lives here too and stays
terminal-agnostic by going through `appIdArgv`.
**Breaks** Left in `foot.nix`, that setter fires for *any* Hyprland host and
appends foot's `--app-id` to whatever terminal the host actually took.

<a id="terminal-desktopfile"></a>
## `terminal/terminal.nix` — `desktopFile` and `binary` carry no default

**Why** They are the only scalars in the namespace. Every other member is a list
or a function, and both **merge by concatenating** rather than conflicting.
**Breaks** Without them nothing rejects a host taking two terminals — two
aspects silently produce `argv = ["…/footclient" "…/kitty"]` and run one as the
other's argument. `aspectRequires` cannot help: it says "needs", never
"excludes". A host taking *no* terminal gets `terminal.argv has no value
defined` — loud, but it does not name the missing aspect.

<a id="terminal-daemons"></a>
## `terminal/*.nix` — all four keep a server, each with a different client

**Why** Opening a window should cost nothing, and each terminal offers that
differently. The aspect owns both halves:

| | server | client |
| --- | --- | --- |
| foot | `foot --server` | `footclient` |
| alacritty | `alacritty --daemon` | `alacritty msg create-window` |
| kitty | `kitty --single-instance --start-as=hidden` | `kitty --single-instance` |
| ghostty | `ghostty --gtk-single-instance=true --initial-window=false` | `ghostty` |

Every server is wired **twice** because the sessions start things differently
(`sessions.md#dwl-autostart`): a systemd user unit for Hyprland, a
`dwl.autostart` entry — a bare name from `~/.nix-profile/bin`, no `'` — for dwl.
**Breaks** A client is useless when its server is down, which is exactly when
you want a terminal, so `fallbackArgv` is a role of its own and both sessions
bind it. Wire only one channel and the terminal is slow on the other session
with nothing to say why.

<a id="kitty-single-instance"></a>
## `terminal/kitty.nix` — the client's argv crosses the socket, but not all of it

**Why** kitty's client ships its whole argv over and the server re-parses it,
but `boss.py`'s handler *uses* only `wclass`, `wname`, `title` and
`opts_for_size`, plus per-window cases for `background_opacity` and
`background_image`.
**Breaks** *Silently, for everything not on that list.* **`-o font_size` is not
on it** — the new window renders in the running instance's font, because
single-instance shares one GPU sprite cache. Check anything that must differ per
spawn against that handler; do not assume it works because `--class` does.

<a id="kitty-compact-group"></a>
## `terminal/kitty.nix` — compact spawns get their own instance group

**Why** `compactArgv` shrinks the font so a 24-row TUI fits the floating window,
and per the entry above a single-instance client cannot change the font.
`--instance-group=compact` makes those spawns a *second* instance, built at
`compactSize` by the first of them; the rest join it and stay cheap. Dropping
`--single-instance` instead works but pays full startup on every btop click.
**Breaks** `compactSize` was measured on **foot**, not kitty — three fifths of
the host font size is where foot's cell metrics put 24 rows in `1200 600`.
Verify with `kitty --instance-group=probe -o font_size=12 bash -c 'sleep 1; stty
size'` and raise the fraction, or the window, if the first number is under 24.

<a id="ghostty-single-instance"></a>
## `terminal/ghostty.nix` — the server serves the plain bind only

**Why** `gtk-single-instance` defaults to `detect`, which switches itself **off**
when `TERM_PROGRAM` is set or when any CLI argument is present. Setting it
`true` explicitly is what makes `SUPER+Return` reuse the running process.
**Breaks** Nothing, and that is worth stating: `-e` independently forces
`gtk-single-instance=false`, and every TUI spawn appends `terminal.exec`
(`["-e"]`). So a transient spawn always forks — slower by design — but always
honours its own `--class`, which a connecting client would have ignored. The two
rules cancel; remove either and floating TUIs stop floating.

<a id="ghostty-enablement"></a>
## `terminal/ghostty.nix` — the unit's `[Install]` symlink is declared by hand

**Why** Home Manager writes ghostty's unit through `xdg.configFile` rather than
`systemd.user.services`, so nothing emits the `graphical-session.target.wants`
symlink an `[Install]` section would.
**Breaks** *Quietly, and only in the first second.* Ghostty's D-Bus service file
carries `SystemdService=`, so the first launch activates the unit anyway — the
symptom is not a broken terminal but the first window of every session paying
for the server.

<a id="ghostty-resident"></a>
## `terminal/ghostty.nix` — `quit-after-last-window-closed` is false

**Why** A server that exits ten minutes after the last window is not a server,
and systemd will not bring it back: the packaged unit is `Type=notify-reload`,
so a clean exit is success.
**Breaks** *Silently, and only after a pause.* Everything is fast until the
first ten idle minutes, after which the next terminal pays full startup and the
session has no server again until the next login.

<a id="terminal-transient"></a>
## `terminal/terminal.nix` — `transientArgv` is named for the lifecycle

**Why** A TUI you open, act in, and close. dwl tiles it, Hyprland floats it, so
neither answer belongs in the name.
**Breaks** Naming it `floatingArgv` would make a spawn point assert a window
behaviour dwl rejects.

<a id="terminal-exec"></a>
## `terminal/terminal.nix` — `exec` sits between the options and the command

**Why** foot and kitty take a bare trailing command; alacritty and ghostty need
`-e`, and alacritty needs it *last*. `transientArgv ++ [prog]` is therefore
correct for only half the terminals, and `exec` names the difference.
**Breaks** *Silently, on ghostty.* An argument it does not recognise as a
command is dropped and a plain shell opens instead. It cannot live inside
`argv`, because `compactArgv` appends a font override after `transientArgv` and
that would land past the `-e`.

<a id="terminal-ansi"></a>
## `theme/colors.nix` — the ANSI table is upstream's, and the index is the slot

**Why** kanagawa.nvim generates the dragon terminal theme for all four from one
table, `themes.lua`'s `dragon.term`. That table is the authority, so
`desktop.ansi` reproduces it exactly rather than deriving it from a slot
convention — and it is one ordered list because written per terminal it would
appear four times in four vocabularies (`regular0`, `colors.normal.black`,
`color0`, `palette = "0=…"`).
**Breaks** *Silently.* Anything reading a colour by number is off by a slot, and
reordering reassigns every colour at once — the trap qt5ct's positional role
list also carries.
**Also** slots 16 and 17 are **not** in the list; they are the 256-cube trick
that is the only way base09 and base0F reach a terminal, so each implementation
reads `colors16` for those, as it does for foreground, background and selection.
The cursor is base05 over base00 in all four, spelled out because every
terminal's default here is a different colour.

<a id="terminal-clipboard-keys"></a>
## `terminal/*.nix` — the dedicated copy/cut/paste keys

**Why** A keyboard sending `KC_COPY`/`KC_CUT`/`KC_PASTE` produces
`XF86Copy`/`XF86Cut`/`XF86Paste`. Three of the four already bind two of the
three; only kitty binds none, which is why it is the one file listing all three.
**Breaks** *Silently, in foot.* A `[key-bindings]` value **replaces** the
default combos rather than adding to them, so `clipboard-copy` has to restate
`Control+Shift+c` and `XF86Copy` alongside the `XF86Cut` it exists to add.
**Also** no terminal has a cut, so the cut key is a copy that does nothing
without a selection. kitty's `copy_and_clear_or_interrupt` was rejected: with no
selection it sends SIGINT, so a stray press would kill a running command.

<a id="terminal-stroke-weight"></a>
## `terminal/*.nix` — red strokes thin out first, and each terminal differs

**Why** sRGB weights luminance R 0.2126, G 0.7152, B 0.0722, so red carries
under a third of green's perceived brightness — on `base00` the ANSI red sits at
5.21, the palette's lowest, against 10.76 for the foreground. Thin antialiased
strokes survive on luminance contrast alone, so red fails first and an undercurl
is the thinnest stroke drawn. kitty takes a multiplicative contrast on glyph
alpha (the second number of `text_composition_strategy`) plus `undercurl_style`;
foot and ghostty take gamma-correct blending, so foot's
`gamma-correct-blending` goes on and ghostty takes `linear` rather than its
default `linear-corrected`, which puts the native thinness back.
**Breaks** *Silently, in three ways.* alacritty has no equivalent at all, so a
host moving to it reverts the fix with nothing to say so. ghostty drops an
unparseable value without a diagnostic. And foot's flag forces the 16- or
10-bit buffers its precision needs, which are slower.
**Also** kitty's contrast number does **not** reach the undercurl —
`cell_fragment.glsl` samples `underline_alpha` after applying
`foreground_contrast()`, never through it — which is why `undercurl_style` sits
beside it. Fix the first number at `1.0` and raise the second until it looks
right.

<a id="kitty-inactive-alpha"></a>
## `terminal/kitty.nix` — `inactive_text_alpha` is negative, and the sign is the setting

**Why** The absolute value is the opacity; the **sign** chooses when fading
applies. Positive fades whenever the OS window loses focus, even with one window
open. Negative restricts it to more than one kitty window being visible — the
state worth indicating, and the one the window manager cannot indicate for you.
**Breaks** *Silently, and worst on the thinnest strokes.* `cell_fragment.glsl`
multiplies both `combined_alpha` and `underline_alpha` by
`effective_text_alpha`, so a positive value fades undercurls with the text — the
coverage failure `#terminal-stroke-weight` exists to fix, reintroduced by a
setting that looks like it is only about focus.
**Also** `-0.8` and `0.8` render identically whenever more than one window is
visible, so they differ only in the single-window case nobody deliberately
tests. That is how a whole-window fade survived every look at the colours.

<a id="kitty-borders"></a>
## `terminal/kitty.nix` — the split borders are ours, not upstream's

**Why** kanagawa.nvim's `extras/kitty/kanagawa_dragon.conf` sets no border
colours, so `enabled_layouts = "splits,stack"` drew kitty's stock green, grey
and orange. These take base0D/base03/base08, the roles `hyprland/general.nix`
gives a window border — a kitty split is the same thing one level down.
**Breaks** *Loudly, but only in a split.* A single window never shows a border,
so this survived every look at the colours until someone opened a split.
**Also** upstream specifies nothing here, so these three are the only terminal
colours in the tree a diff against `extras/` cannot check.

<a id="ghostty-shader"></a>
## `terminal/ghostty.nix` — the cursor shader, and what kitty does instead

**Why** ghostty is the only one of the four running a custom fragment shader, so
`cursor_smear.glsl` is interpolated to a store path rather than a source path —
`pkgs.formats.keyValue` takes atoms, not paths. kitty refuses custom shaders as
policy; its `cursor_trail` is the same effect, cell-aware and idle when the
cursor is still, where ghostty's `custom-shader-animation` redraws every frame.
**Breaks** *Silently.* A shader that fails to compile is ignored and says so
only in the log. The power asymmetry matters if either aspect lands on `swift5`.

<a id="ghostty-scrollback"></a>
## `terminal/ghostty.nix` — `scrollback-limit` is bytes, and stays unset

**Why** Every other terminal here counts lines. ghostty counts **bytes**, and
its default is 10 MB; the `50000` this file was revived from reads like foot's
10 000 lines and is in fact 50 KB.
**Breaks** *Silently.* Roughly a hundredth of the intended scrollback, with
nothing to indicate the unit was misread.

<a id="kitty-font-option"></a>
## `terminal/kitty.nix` — the font comes from `programs.kitty.font`

**Why** Home Manager emits `font` at `mkOrder 510` and `settings` at 540, so
`settings.font_size` would be written second and shadow the option.
**Breaks** *Silently, in the wrong direction* — the value that loses is the one
declared in the obvious place.

<a id="kitty-cursor-trail"></a>
## `terminal/kitty.nix` — `wheel_scroll_multiplier` is not ghostty's number

**Why** ghostty's `mouse-scroll-multiplier = 0.95` scales its own default.
kitty's defaults to `5.0` and is *lines per event*, so copying 0.95 across would
ask for less than one line per notch.
**Breaks** Scrolling that feels broken rather than tuned. The rule for this
pair: the settings are analogous, the units are not.

<a id="terminal-compact"></a>
## `terminal/terminal.nix` — `compactSize` is three fifths of the host font size

**Why** Measured on UM790pro against Hyprland's `floating-size` of `1200 600`:
20pt gives 17x88, 14pt gives 24x126, 12pt gives 28x148. btop refuses to start
under 24x60, so the full size misses it by seven rows. Three fifths lands on
12pt there. The measurement is shared; the flag carrying it is not, because
foot's override re-renders the whole font spec where the other three take a
bare number.
**Breaks** btop exits with "Terminal size too small" rather than opening. Any
change to `floating-size`, a host's `fontSize`, or this fraction moves the row
count — measure with `footclient -o main.font=... bash -c 'sleep 1; stty size'`.
Write `font.size * 3 / 5` with the spaces: `3/5` is a path literal.

<a id="terminal-appid"></a>
## `terminal/terminal.nix` — `appIdArgv` is a function, not a flag name

**Why** The four spellings differ in shape, not just text: foot takes
`--app-id <id>`, alacritty and kitty `--class <id>`, and ghostty accepts **only**
`--class=<id>`.
**Breaks** *Silently.* ghostty given the space form swallows it with no
diagnostic, so a `flag` string plus `[flag id]` would leave ghostty windows
unnamed and every floating TUI tiled.

<a id="terminal-alt-scroll"></a>
## `terminal/foot.nix` — `alternate-scroll-mode` is foot's alone

**Why** It stops the wheel sending arrow keys in the alternate screen, so
scrolling a full-screen TUI scrolls the terminal instead of walking shell
history.
**Breaks** *Silently, on three terminals out of four.* alacritty, kitty and
ghostty have no equivalent, so choosing another terminal quietly reverts it.

<a id="kitty-split-navigation"></a>
## `terminal/kitty.nix` — the four keys are bound, then conditionally unbound

**Why** kitty sees the keypress before the program does, so
`map ctrl+h neighboring_window left` alone would take `C-h` from Neovim
entirely. smart-splits.nvim writes an `IS_NVIM` user-var over OSC 1337, and the
four `map --when-focus-on var:IS_NVIM ctrl+h` lines with an empty action unbind
the key again *for windows that have it*. The reverse trip goes over `kitty @`,
which is what `allow_remote_control` and `listen_on` are for.
**Breaks** Silently, and `listen_on` is the sharp half: it puts
`KITTY_LISTEN_ON` in the environment, the *only* thing smart-splits tests to
decide it is talking to kitty. Drop it and the plugin reports no multiplexer,
navigation stops at the last Neovim window, and nothing says why.
`echo $KITTY_LISTEN_ON` is the check.
**Also** the unbind lines live in `extraConfig` because their action is empty
and the `keybindings` attrset cannot express that; the default order 1000 lands
after `settings` (540) and `keybindings` (560) in the same string.

<a id="ghostty-split-arrows"></a>
## `terminal/ghostty.nix` — the splits keep the arrows, and kitty's did not

**Why** Ghostty cannot do what kitty does above, and the gap is structural: no
conditional-keybind mechanism, no implemented OSC 1337 `SetUserVar` to test, and
a Linux D-Bus surface reaching `+new-window` only. Its one state-aware prefix,
`performable:`, asks whether *Ghostty* can perform the action, never whether the
child should have had the key first. The divergence is the decision, not drift.
**Breaks** Silently, in the direction that looks like success.
`performable:ctrl+h=goto_split:left` works whenever Ghostty has no split that
way — most of the time you would test it — and the moment a Ghostty split *and*
a Neovim window both sit left, Ghostty wins and that window is unreachable.
smart-splits closed its Ghostty backend (PR #433) on exactly this.
**Also** ghostty is in no host's aspect list today, so this costs nothing now;
it is written down so the arrows are not "fixed" into `hjkl` later.

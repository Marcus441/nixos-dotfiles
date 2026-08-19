# Sessions

dwl, Hyprland, and the bars.

<a id="dwl-column0"></a>
## `dwl/dwl.nix` — nothing may be spliced at column 0

**Why** dwl is configured at compile time; each generated fragment lands at
column 0 of the output.
**Breaks** *Silently.* `''` strips the least indentation, and a line starting
`${…}` has none — so one column-0 interpolation sets the block's strip depth to
zero and reindents the entire generated file. `toggleBarKey` sits inside an
array, so it carries the two spaces `''` would otherwise have stripped.

## `dwl/dwl.nix` — two escapers, `argvC` and `cEsc`

**Why** dwl's binds are a C argv array, but the intent options hold *shell*
commands and `SHCMD` embeds those in a C string literal.
**Breaks** Using one where the other belongs compiles, then misbehaves at
runtime.

## `dwl/dwl.nix` — the status pipe is dropped, not fed from `/dev/null`

**Why** An unpatched dwl reads nothing from stdin.
**Breaks** Feeding it anyway is a loop running forever for nobody.

<a id="dwl-session"></a>
## `dwl/dwl.nix` — the session runs the user's profile copy

**Why** dwl is compiled in the dwl *home* aspect, so the session launches
`~/.nix-profile`'s copy.
**Breaks** `home-manager switch` becomes a prerequisite for the dwl aspect —
needed anyway for bash, the terminal, fonts and dwl-monitors.

<a id="dwl-autostart-core"></a>
## `dwl/dwl.nix` — `dwl.autostart` is declared in `core`, `statusCommand` in `dwl`

**Why** The terminal server is an autostart entry now, and the aspect that owns
it is a terminal, not a session — it cannot know whether the host runs dwl. So
the option is declared where every host has it and read only by the session, the
`windowTags` shape. `statusCommand` stays in `dwl`: only `dwl-bar` sets it, and
`aspectRequires.dwl-bar = ["dwl"]` already guarantees they arrive together.
**Breaks** A setter outside the `dwl` aspect hits an undeclared option on every
host that does not take dwl. A host taking a terminal but not dwl carries the
entry inertly, which is the point.
**Also** the rendered order is **not** the host's aspect order: swift5 lists
`core` before `dwl`, yet the `core` entry lands *after* the `dwl` one — measured,
`dwl-idle & foot --server &`. Nothing depends on it; anything that does must be
measured (AGENTS.md §5).

<a id="dwl-autostart"></a>
## `dwl/dwl.nix` — `dwl.autostart`, because the `-s` string is the only channel

**Why** `graphical-session.target` is never reached on swift5: `ly.nix` marks
the display manager `X-NIXOS-SYSTEMD-AWARE`, which suppresses nixpkgs'
`nixos-fake-graphical-session.target`, and uwsm — which creates the real targets
— is Hyprland-only. A file wanting a session process therefore adds a name to
`dwl.autostart` and builds it home-side, the `dwl.statusCommand` / `dwl-monitors`
shape; the session script stays ignorant of what it starts.
**Breaks** *Silently, twice.* A home-manager `services.*` unit here installs,
carries `WantedBy=graphical-session.target`, and never starts — as
foot's own `foot.service` already does not. And the `-s` argument is single-quoted, so an
entry containing `'` truncates the session script.

<a id="dwl-idle-dpms"></a>
## `lock/swayidle.nix` — `-w` with `-f`, `wlopm` for the screen, one saved brightness

**Why** `-w` holds swayidle's logind sleep inhibitor open until `before-sleep`
returns, so the lock surface exists before the machine goes down; dwl 0.8
implements `wlr_output_power_manager_v1` (`powermgrsetmode` in dwl.c), so
blanking need not go through output *configuration*; and `brightnessctl -s`
belongs to the 180s step alone.
**Breaks** *Silently, in three directions.* `-w` waits on **every** command, so
a locker without `-f` blocks swayidle for the whole lock and the 600s and 1200s
steps never fire — a lit lock screen until the battery is flat. `wlr-randr
--off` blanks too, but disabling an output makes dwl move that output's tags and
clients elsewhere. And a second `-s` further down the ladder overwrites the
saved level with the dimmed one, so `-r` restores 30 for good.

## `lock/swayidle.nix` — no `unlock` event

**Why** `loginctl unlock-session` needs no authentication from inside the
session it unlocks. hypridle answers no such signal either.
**Breaks** *By design, invisibly.* Wiring one turns the lock screen into a
formality that any process in the session can dismiss.

<a id="swaylock-pam"></a>
## `lock/swaylock.nix` — the PAM service is ours to declare

**Why** nixpkgs supplies `security.pam.services.swaylock` only from
`wayland-session.nix`, which the dwl session does not use. `hyprland/hyprland.nix` keeps
hyprlock's line for the same reason.
**Breaks** *At the worst moment.* The lock screen appears and the correct
password is refused; the way out is a VT switch.

<a id="dwl-bar-status"></a>
## `bar/dwl-bar.nix` — the status feed crosses classes

**Why** The bar reads status from dwl's stdin, and the session script holding
that pipe is in the nixos half, which cannot see homeManager config.
**Breaks** Declaring it home-side leaves the pipe with nothing to carry.

<a id="quickshell-requires"></a>
## `quickshell/quickshell.nix` — requires `hyprland`, and never locks

**Why** The shell reads Hyprland IPC for workspaces, binds a systemd target
only uwsm-under-Hyprland creates, and drives hyprpaper over `hyprctl`. It
stays out of the security surface on purpose: locking is only ever
`lock.command` (`loginctl lock-session`, so hypridle runs hyprlock), and idle
inhibition is the Wayland protocol, which hypridle honours.
**Breaks** Without the requirement a dwl host gets a dead bar instead of a
rejection; a `WlSessionLock` in the shell would make a QML crash unlock the
screen.

<a id="quickshell-notifs"></a>
## `quickshell/_qml/services/Notifs.qml` — the shell owns notifications

**Why** On Hyprland hosts the shell claims `org.freedesktop.Notifications`
itself (`NotificationServer` in a singleton), so toasts and the bar's
notification center share one in-process state instead of shelling out to a
daemon. The server cannot be lazy — the D-Bus name must be claimed at startup
— so `shell.qml` instantiates the singleton through the `Toasts` loader's
`active` binding while the toast window itself only exists while a toast is
showing. Do-not-disturb is a `PersistentProperties` bool: it survives QML
reloads but deliberately not restarts — no state file. History is
`trackedNotifications` directly, capped at 50; visible toasts cap at 5; the
only timers are per-toast, so an idle shell holds zero timers.
**Breaks** A second daemon racing for the D-Bus name — mako serves only dwl
for exactly this reason. Critical toasts persist until dismissed and DND
suppresses toasts for every urgency (history still records); both are
deliberate deltas from the old mako behaviour.

<a id="layout-event"></a>
## `hyprland/_layout.lua` — layout changes announce a `custom>>layout,` event

**Why** The bar's layout indicator needs to react the instant a bind switches
layouts, and Hyprland emits no IPC event for a runtime config change — so
`layout.set` emits one itself: `hl.dsp.event("layout," .. name)` lands on
socket2 as `custom>>layout,<name>`, where the LayoutState singleton's
existing `onRawEvent` picks it up. Events are ephemeral, so LayoutState still
reconciles against `hyprctl getoption` at startup and on `configreloaded` —
a restart re-reads the generated config and no event fires for that. The
event keeps the coupling one-way — `hyprland` files never hold a quickshell
store path, and a host without `quickshell` emits an event nobody hears.
`layout.set` is the single entry point — every layout bind routes through
it, and it also applies the per-layout visual profile
(#monocle-visual-profile). This replaced a `$XDG_CACHE_HOME/hyprland-layout`
file written by shell scripts — an event cannot go stale the way the file
outliving the session did.
**Breaks** *Silently, on rename.* The `layout,` payload prefix is
string-matched in two aspects (`_layout.lua` and `LayoutState.qml`);
changing it in one place leaves the indicator frozen on its startup
`getoption` fallback.

<a id="monocle-visual-profile"></a>
## `hyprland/_layout.lua` — layout.set applies the per-layout visual profile

**Why** Monocle should render edge-to-edge: no gaps, no border, no
animations. Rules cannot express "when the layout is monocle" — the
`w[tv1]`/`f[1]` rules only fire with a single tiled window, so a monocle
workspace with a stacked window kept its gaps and popin artifacts. The
profile rides the same `hl.config` call that switches the layout, and the
restore branch replays a snapshot that entering monocle took from the live
values (`hl.get_config`), so it can never drift from
`general.nix`/`animations.nix` — it restores whatever the generated config
set. The snapshot is only taken when not already in monocle, so a repeated
`layout.set("monocle")` cannot capture the zeroed profile. Disabling
`animations.enabled` is a master switch — layer animations pause in monocle
too; per-leaf runtime control is not exposed through `hl.config`.
**Breaks** A reload or restart while in monocle re-reads the generated
config — dwindle, normal gaps — and LayoutState's `configreloaded` re-query
(#layout-event) keeps the indicator in step with it; the snapshot dies with
the Lua state, which is correct because the profile it saved died too.
Hardcoding the restore values instead of snapshotting reintroduces drift.

<a id="hyprland-luarc"></a>
## `hyprland/hyprland.nix` — the `.luarc.json` is hand-written

**Why** Home Manager generates `hypr/.luarc.json` (lua-language-server
wired to Hyprland's official `hl` API stubs) only when it owns the Hyprland
package, and this config sets `package = null` because the NixOS module
installs Hyprland. The hand-written copy restores LSP for `_layout.lua`
using the same `pkgs.hyprland` the system installs.
**Breaks** *Loudly, on un-nulling.* If `package` ever stops being null,
Home Manager defines the same `xdg.configFile` path and the build fails on
the conflict — delete this block then.

<a id="floating-appid"></a>
## `hyprland/floating-windows.nix` — the limit of the app-id convention

**Why** An app that can name itself opts in at spawn time:
`footclient --app-id term.floating` floats, plain `footclient` tiles.
**Breaks** app-id is set by the client, and Wayland has no outside override the
way X11 had `--class`. pavucontrol, blueman-manager and thunar take no flag, and
xdg-desktop-portal-gtk is D-Bus activated with no spawn site, so those four
match their real class — which floats **every** instance. Accepted: a title
match or a rename wrapper both break silently instead.

<a id="floating-gtk-id"></a>
## `hyprland/floating-windows.nix` — the app-ids are dotted, and the regex escapes the dot

**Why** ghostty parses `--class` as a GTK application ID, which must carry at
least one period. `floating-term` is not one, so the id both terminals and GUI
utilities announce is `term.floating` / `app.floating` — one spelling all four
terminals accept.
**Breaks** *Silently, twice.* ghostty given an invalid class exits 0, logs a
warning nobody reads, falls back to `com.mitchellh.ghostty`, and the TUI tiles.
And a raw dot in the tag regex is a wildcard — `^(term.floating)$` also matches
`termXfloating` — so the value goes through `lib.escapeRegex`.

<a id="hyprland-rules-regex"></a>
## `hyprland/rules.nix` — one rule per regex, not one alternation

**Why** The regexes arrive from separate files, so joining them would mean
wrapping each in a group the contributing file cannot see it needs.
**Breaks** An unwrapped alternation silently changes what each regex matches.

## `xdg.nix` — the environment file is Hyprland-only

**Why** uwsm reads it to inherit home-manager's session variables. dwl sources
them from the login shell, so swift5 has no use for the file.

<a id="uwsm-login-shell"></a>
## `hyprland/hyprland.nix` — session startup lives in the `hyprland` aspect

**Why** Session startup wearing shell clothing: the login shell is only the
channel, the decision is Hyprland. It held it for as long as there was one
shell; with two it sets both `profileExtra` slots from one string, in the file
that already turns uwsm on.
**Breaks** *Silently.* A zsh login shell reads `~/.zprofile` and never
`~/.profile`, so dropping the second slot leaves no error and no session — just
a shell prompt where the compositor should have been.
**Also** This is the tty-login path, not the one in use — ly launches
`hyprland-uwsm.desktop` through `xsession-wrapper`, where `uwsm check may-start`
then fails because ly set `XDG_SESSION_TYPE` before PAM. What reaches the block
is a VT login or `ssh`. Proven on UM790pro: `journalctl -b -t uwsm_start` is
empty while Hyprland runs.

# Sessions

dwl, Hyprland, and the bars.

<a id="dwl-column0"></a>
## `dwl.nix` — nothing may be spliced at column 0

**Why** dwl is configured at compile time; each generated fragment lands at
column 0 of the output.
**Breaks** *Silently.* `''` strips the least indentation, and a line starting
`${…}` has none — so one column-0 interpolation sets the block's strip depth to
zero and reindents the entire generated file. `toggleBarKey` sits inside an
array, so it carries the two spaces `''` would otherwise have stripped.

## `dwl.nix` — two escapers, `argvC` and `cEsc`

**Why** dwl's binds are a C argv array, but the intent options hold *shell*
commands and `SHCMD` embeds those in a C string literal.
**Breaks** Using one where the other belongs compiles, then misbehaves at
runtime.

## `dwl.nix` — the status pipe is dropped, not fed from `/dev/null`

**Why** An unpatched dwl reads nothing from stdin.
**Breaks** Feeding it anyway is a loop running forever for nobody.

<a id="dwl-session"></a>
## `dwl.nix` — the session runs the user's profile copy

**Why** dwl is compiled in the dwl *home* aspect, so the session launches
`~/.nix-profile`'s copy.
**Breaks** `home-manager switch` becomes a prerequisite for the dwl aspect —
needed anyway for bash, the terminal, fonts and dwl-monitors.

<a id="dwl-autostart-core"></a>
## `dwl.nix` — `dwl.autostart` is declared in `core`, `statusCommand` in `dwl`

**Why** The terminal server is an autostart entry now, and the aspect that owns
it is a terminal, not a session — it cannot know whether the host runs dwl. So
the option is declared where every host has it and read only by the session, the
`windowTags` shape. `statusCommand` stays in `dwl`: only `dwl-bar` sets it, and
`aspectRequires.dwl-bar = ["dwl"]` already guarantees they arrive together.
**Breaks** A setter outside the `dwl` aspect hits an undeclared option on every
host that does not take dwl. A host taking a terminal but not dwl carries the
entry inertly, which is the point.
**Also** the rendered order is **not** the host's aspect order. swift5 lists
`core` before `dwl`, and the entry set from `core` still lands *after* the one
set from `dwl` — measured, `dwl-idle & foot --server &`. Nothing here depends on
it; anything that does must be measured, not reasoned about (CLAUDE.md §5).

<a id="dwl-autostart"></a>
## `dwl.nix` — `dwl.autostart`, because the `-s` string is the only channel

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
## `swayidle.nix` — `-w` with `-f`, `wlopm` for the screen, one saved brightness

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

## `swayidle.nix` — no `unlock` event

**Why** `loginctl unlock-session` needs no authentication from inside the
session it unlocks. hypridle answers no such signal either.
**Breaks** *By design, invisibly.* Wiring one turns the lock screen into a
formality that any process in the session can dismiss.

<a id="swaylock-pam"></a>
## `swaylock.nix` — the PAM service is ours to declare

**Why** nixpkgs supplies `security.pam.services.swaylock` only from
`wayland-session.nix`, which the dwl session does not use. `hyprland.nix` keeps
hyprlock's line for the same reason.
**Breaks** *At the worst moment.* The lock screen appears and the correct
password is refused; the way out is a VT switch.

<a id="dwl-bar-status"></a>
## `bar/dwl-bar.nix` — the status feed crosses classes

**Why** The bar reads status from dwl's stdin, and the session script holding
that pipe is in the nixos half, which cannot see homeManager config.
**Breaks** Declaring it home-side leaves the pipe with nothing to carry.

<a id="waybar-requires"></a>
## `bar/waybar.nix` — requires `hyprland`

**Why** It reads `hyprland/window`, shells to `hyprctl`, and binds a systemd
target only uwsm-under-Hyprland creates.
**Breaks** Without the requirement a dwl host is handed three dead modules
instead of a rejection.

<a id="floating-appid"></a>
## `floating-windows.nix` — the limit of the app-id convention

**Why** An app that can name itself opts in at spawn time:
`footclient --app-id term.floating` floats, plain `footclient` tiles.
**Breaks** app-id is set by the client, and Wayland has no outside override the
way X11 had `--class`. Every terminal takes the flag, under three spellings
(`--app-id`, `--class`, `--class=`); pavucontrol, blueman-manager and thunar
have none, and xdg-desktop-portal-gtk is D-Bus activated with no spawn site.
Those four match their real class, which floats **every** instance. Accepted —
a title match or a rename wrapper both break silently instead.

<a id="floating-gtk-id"></a>
## `floating-windows.nix` — the app-ids are dotted, and the regex escapes the dot

**Why** ghostty parses `--class` as a GTK application ID, which must carry at
least one period. `floating-term` is not one, so the id both terminals and GUI
utilities announce is `term.floating` / `app.floating` — one spelling all four
terminals accept.
**Breaks** *Silently, twice.* ghostty given an invalid class exits 0, logs a
warning nobody reads, falls back to `com.mitchellh.ghostty`, and the TUI tiles.
And a raw dot in the tag regex is a wildcard — `^(term.floating)$` also matches
`termXfloating` — so the value goes through `lib.escapeRegex`.

<a id="wleave-no-anim"></a>
## `wleave-style.nix` — appearing instantly takes a rule and a stylesheet, not one

**Why** Two animators, neither of which is wleave: Hyprland fades the layer
surface in, and libadwaita transitions the button that keyboard focus lands on.
The layer rule in `hyprland-rules.nix` kills the first, `transition: none` on
`*` kills the second. wleave itself ships no CSS animation at all.
**Breaks** Fixing one leaves the other. Deleting our own `transition` from
`button` does not reach libadwaita's — the reset has to be an override, not an
absence. wleave is GTK4 (`libgtk-4`, `libadwaita-1`, `gtk4-layer-shell`), not
GTK3, so the properties it accepts are GTK4's; check against that library
before adding one.
**Also** the same override-not-absence rule is why `button` restates
`background-image: none` and `box-shadow: none`: libadwaita gives a button a
gradient and a shadow, and neither survives contact with a flat palette.

<a id="wleave-focus"></a>
## `wleave-style.nix` — the keybind dims by opacity, not by colour

**Why** The per-button hues are ID selectors (`#lock`, `#shutdown`, …) and the
icons are `currentColor` SVGs, so one `color` sets icon and label together. An
ID outranks `button label.keybind`, so muting the keybind with `color` would
lose the cascade silently; `opacity` sidesteps specificity entirely. Upstream's
own sheet mutes it the same way.
**Also** the border stays 2px in every state and only changes colour, so
focusing a button reflows nothing. Resting `base03`, focused `base0D` — that is
Hyprland's `inactive_border`/`active_border` pair verbatim, so a focused button
marks where you are exactly as a focused window does. `base02` stays in the file
for the hover *background*; only the frame carries state.

<a id="wleave-service"></a>
## `wleave.nix` — the unit names the config files it is already reading

**Why** wleave is a `gio` application run with `--service`: it holds itself
alive and D-Bus activates on the next bare `wleave`, so `powerMenu.command` is
unchanged. Upstream warns that the resident instance owns the configuration
until it restarts.
**Breaks** *Silently.* Passing `--layout`/`--css` by store path is what makes
home-manager's sd-switch see a changed unit and restart it; pointed at
`%h/.config` instead, the unit never changes and an edited menu keeps rendering
the old one until reboot.

<a id="wleave-toggle"></a>
## `wleave.nix` — the bind toggles, because a resident wleave will not

**Why** wleave 0.7.1's `connect_activate` builds a window unconditionally, so a
resident instance grows one layer surface per keypress, and `app/mod.rs` guards
close-on-lost-focus with `&& !service_mode`, so none of them close. Before the
service the second half hid the first — the older window died as the newer took
focus. `powerMenu.command` is therefore a script: restart the unit if a wleave
layer is mapped, activate if none is. Restarting is the only close available
from outside, since a layer surface is not a window a compositor can shut.

**Breaks** *Silently, and only under a held key.* `StartLimitIntervalSec = 0` is
what keeps the toggle from tripping systemd's default five-starts-in-ten-seconds
limit and leaving the unit dead with no menu at all. The detection string is
`namespace: wleave` from `hyprctl layers`; `hyprctl` is called by bare name
because the running compositor is what provides it, and the branch is skipped
where there is none.

<a id="hyprland-rules-regex"></a>
## `hyprland-rules.nix` — one rule per regex, not one alternation

**Why** The regexes arrive from separate files, so joining them would mean
wrapping each in a group the contributing file cannot see it needs.
**Breaks** An unwrapped alternation silently changes what each regex matches.

## `xdg.nix` — the environment file is Hyprland-only

**Why** uwsm reads it to inherit home-manager's session variables. dwl sources
them from the login shell, so swift5 has no use for the file.

<a id="uwsm-login-shell"></a>
## `hyprland.nix` — session startup lives in the `hyprland` aspect

**Why** Session startup wearing shell clothing: the login shell is only the
channel, the decision is Hyprland. It held it for as long as there was one
shell; with two it sets both `profileExtra` slots from one string, in the file
that already turns uwsm on.
**Breaks** *Silently.* A zsh login shell reads `~/.zprofile` and never
`~/.profile`, so dropping the second slot leaves no error and no session — just
a shell prompt where the compositor should have been.
**Also** This is the tty-login path, not the one in use. ly launches
`hyprland-uwsm.desktop` through nixpkgs' `xsession-wrapper`, which sources
`~/.profile` itself — where `uwsm check may-start` then fails, because ly set
`XDG_SESSION_TYPE` before PAM. What reaches the block is ly's synthetic `shell`
entry, a VT login, or `ssh`. Proven on UM790pro: `journalctl -b -t uwsm_start`
is empty while Hyprland runs.

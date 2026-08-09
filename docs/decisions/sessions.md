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
needed anyway for bash, foot, fonts and dwl-monitors.

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
`footclient --app-id floating-term` floats, plain `footclient` tiles.
**Breaks** app-id is set by the client, and Wayland has no outside override the
way X11 had `--class`. Only foot takes the flag; pavucontrol, blueman-manager
and thunar have none, and xdg-desktop-portal-gtk is D-Bus activated with no
spawn site. Those four match their real class, which floats **every** instance.
Accepted — a title match or a rename wrapper both break silently instead.

<a id="wleave-no-anim"></a>
## `wleave.nix` — appearing instantly takes a rule and a stylesheet, not one

**Why** Two animators, neither of which is wleave: Hyprland fades the layer
surface in, and libadwaita transitions the button that keyboard focus lands on.
The layer rule in `hyprland-rules.nix` kills the first, `transition: none` on
`*` kills the second. wleave itself ships no CSS animation at all.
**Breaks** Fixing one leaves the other. Deleting our own `transition` from
`button` does not reach libadwaita's — the reset has to be an override, not an
absence. wleave is GTK4 (`libgtk-4`, `libadwaita-1`, `gtk4-layer-shell`), not
GTK3, so the properties it accepts are GTK4's; check against that library
before adding one.

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

## `bash.nix` — session startup lives in the `hyprland` aspect

**Why** Session startup wearing shell clothing: the login shell is only the
channel, the decision is Hyprland.

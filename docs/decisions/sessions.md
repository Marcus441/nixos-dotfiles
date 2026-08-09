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

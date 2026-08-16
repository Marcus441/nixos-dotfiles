# Display and boot

<a id="render-identify"></a>
## `display/render.nix` — `desc:` vs connector

**Why** Hyprland resolves `desc:` against EDID, which survives a monitor moving
port. wlr-randr and dwl have no equivalent, so they always take the connector.
**Also** `assertionsFor` lives here because monitors are only read by home
modules, so that is where a bad layout gets caught.

## `lock/hyprlock.nix` — font size scales with physical height

**Why** `height / 11` keeps the physical size consistent: 1080 / 11 ≈ 98,
2160 / 11 ≈ 196. The date takes `height / 30` and sits one clock-font-size
below it, `height / 4 - height / 11`, so the gap scales with the pair rather
than being a fixed pixel count that closes up on a 4K panel.
**Also** `top = config` captures flake-parts' config because surfaced files are
flake-parts modules and reach `flake.lib` directly.

<a id="hyprlock-flat"></a>
## `lock/hyprlock.nix` — the background is dimmed instead of the text being shadowed

**Why** Every other surface in the desktop is flat, but hyprlock draws over a
screenshot, and unshadowed `base05` needs a dark enough field to read on. `brightness = 0.35` with `vibrancy = 0.0`
sinks the blurred desktop far enough that the shadow is unnecessary, which is
what lets the clock, the date and the input field all go flat.
**Breaks** The trade is against a bright wallpaper. If the clock ever washes
out, `brightness` is the value to lower — putting `shadow_passes` back would
re-introduce the one non-flat element on the lock screen.
**Also** the input field is the only floating surface here, so it carries the
2px `base0D` frame over `base00` that mako and walker use, squared off with
`rounding = 0`. The dots stay round (`dots_rounding = -1`) rather than
inheriting that zero (`-2`) — square dots on a square field read as a row of
blocks rather than as typed characters.

<a id="boot-timeout"></a>
## `boot.nix` — `timeout = 0`

**Why** No boot menu delay.
**Breaks** **Hold the space bar at boot to reach the generation menu.** With a
zero timeout there is no other way in.

## Generated files

`hosts/*/hardware-configuration.nix` are `nixos-generate-config` output. They
keep their upstream banner; the commented-out per-interface `useDHCP` lines are
upstream's template. Regenerate rather than hand-edit.

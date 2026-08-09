# Display and boot

<a id="render-identify"></a>
## `display/render.nix` — `desc:` vs connector

**Why** Hyprland resolves `desc:` against EDID, which survives a monitor moving
port. wlr-randr and dwl have no equivalent, so they always take the connector.
**Also** `assertionsFor` lives here because monitors are only read by home
modules, so that is where a bad layout gets caught.

## `hyprlock.nix` — font size scales with physical height

**Why** `height / 11` keeps the physical size consistent: 1080 / 11 ≈ 98,
2160 / 11 ≈ 196.
**Also** `top = config` captures flake-parts' config because surfaced files are
flake-parts modules and reach `flake.lib` directly.

<a id="boot-timeout"></a>
## `boot.nix` — `timeout = 0`

**Why** No boot menu delay.
**Breaks** **Hold the space bar at boot to reach the generation menu.** With a
zero timeout there is no other way in.

## Generated files

`hosts/*/hardware-configuration.nix` are `nixos-generate-config` output. They
keep their upstream banner; the commented-out per-interface `useDHCP` lines are
upstream's template. Regenerate rather than hand-edit.

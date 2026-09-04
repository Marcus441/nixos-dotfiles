# quickshell

The shell's overlays and the services behind them. Session-level decisions —
which aspect owns which intent, who claims the notification bus — are in
`sessions.md`; the Super+Tab tree is in `switcher.md`.

<a id="quickshell-overlay-screen"></a>
## `lib/Overlay.qml` — no `screen` binding

**Why** A modal must open on the monitor the user is looking at, and it already
does: `PanelWindow` leaves `wl_output` null when `screen` is unset, and
wlr-layer-shell leaves the choice to the compositor, which Hyprland resolves to
the focused monitor. Binding `screen` would replace working compositor policy
with a `HyprlandMonitor.name` → `ScreenInfo.name` bridge — `HyprlandMonitor` has
no `screen` property and `Quickshell.screens` is a list property, not an array —
and would then need pinning after construction, because assigning `screen` to a
mapped window destroys and re-creates the surface. All of that to reproduce the
default.

Measured, in a nested compositor with two outputs, opening the launcher with
each focused in turn: it lands on WAYLAND-1 when WAYLAND-1 has focus and on
HEADLESS-1 when HEADLESS-1 does, with no `screen` binding anywhere.

**Breaks** *Silently.* `Quickshell.screens[0]` is not the focused monitor, and
`PanelWindow.screen` reads back as that first screen even while the surface sits
on another. Reading the property is what makes this look broken; it is the
compositor, not quickshell, that places the surface.

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

<a id="quickshell-hover-guard"></a>
## `lib/PointerGuard.qml` — hover selects on movement, not on entry

**Why** A modal maps under wherever the pointer already is. Wayland then sends
an enter plus a motion for a pointer that never moved, Qt reports both as a
hover, and `onEntered` hands the selection to whatever row happens to sit under
the cursor. Delegates select on `onPositionChanged` instead, and only when
`PointerGuard.moved` says the position differs from the last one seen.
Coordinates are mapped to the window first, because row-local ones are
identical on every row.

Measured, opening the launcher with the pointer parked and never moved: it
takes row 1 with the pointer at y=598 and row 5 at y=750, rather than the
seeded row 0 it takes when the pointer rests above the list.

**Breaks** *Silently, and it reads as the picker's fault.* The seeded selection
is the casualty — alt-tab lands on the wrong window, and the launcher's first
result is not the one that runs — so the seeding looks broken instead.

<a id="quickshell-layer-namespaces"></a>
## the overlays name their layer, in two files each

**Why** An overlay opened from a keybind that animates in reads as lag, so
`quickshell/layers.nix` renders every name in `quickshell.overlayNamespaces`
into a Hyprland `layer_rule { no_anim = true }`. The match is on the string, so
each name exists twice: once as `WlrLayershell.namespace` in the QML, once in
the `overlayNamespaces` list. Each list entry sits in the file that owns the
matching intent — launcher and clipboard in `launcher.nix`, switcher in
`switcher.nix`, power menu in `quickshell.nix` — so a name arrives with the
thing that opens it rather than in a central list.

**Breaks** *Silently.* Rename one side and the rule stops matching: the overlay
animates in, and nothing errors. An unnamed overlay is the same failure with
nothing to rename — the clipboard and the power menu both fell back to the bare
`quickshell` namespace, which no rule matches, so both animated while the
launcher and the switcher did not.

<a id="quickshell-launcher-usage"></a>
## `services/LauncherUsage.qml` — a singleton, and a cache

**Why** Ranking results by use means writing a file at the moment one launches.
The popup cannot own that file: `shell.qml` holds the Launcher in a
`LazyLoader` keyed on `Popups.launcherOpen`, and `launch()` calls `dismissed()`
on the line after it records, so an in-popup `FileView` would race its own
destruction on every write. A singleton outlives the popup.

It lives under `cacheDir` because it is a cache — it holds nothing that using
the launcher again would not rebuild, so deleting it must be harmless.
`printErrors: false` is what keeps a first run silent, there being no file yet,
and a parse failure falls back to empty counts.

Measured in a nested compositor: a fresh shell lists alphabetically and writes
nothing; three launches of one entry, two of another and one of a third leave
`{"nvim":3,"btop":2,"org.kde.kdenlive":1}` and that order; a restarted shell
reads it back and lists the same.

**Breaks** *Quietly, and in the safe direction.* Ties break alphabetically, so
a lost file degrades to the old alphabetical list. Watch for the opposite:
counts that never persist look exactly like a launcher not yet used.

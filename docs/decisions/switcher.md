# Switcher

The Super+Tab tree of workspaces and their windows.

<a id="quickshell-switcher"></a>
## `quickshell/_qml/popups/Switcher.qml` — the request waits for Hyprland's focus restore

**Why** Hyprland will not move window focus while a layer surface holds
`WlrKeyboardFocus.Exclusive`, and unmapping that surface makes it *restore*
focus — to the most recent window of whatever workspace it lands on, on top of
anything dispatched first. So `activate` hands the request to
`services/FocusRequest.qml`, which waits for the `activewindowv2` announcing
that restore before dispatching; its 200 ms timer is the fallback for a restore
that never announces itself. Measured in monocle: dispatching in the same call
focused the workspace's last window, not the chosen one, every time. The
deferral is a singleton so dismissal is immediate and the request cannot die
with the overlay. `toplevel.wayland.activate()` is inert here in every state —
it only marked the workspace urgent, the bar's red pill.
**Breaks** *Silently, and it reads as the picker's fault.* Dispatching without
the wait still picks the right window on a one-window workspace, so the bug
survives every single-window test and appears only where a workspace holds two.
**Also** the `quickshell-switcher` layershell namespace is string-matched in
two files — here and the `quickshell.overlayNamespaces` entry in
`switcher.nix`, which `quickshell/layers.nix` renders into a `no_anim` rule —
both in the `quickshell` aspect. Rename it in one and the overlay animates.

## `quickshell/_qml/popups/Switcher.qml` — a request names a window, never a bare workspace id

**Why** Hyprland reads a leading `-` in a workspace argument as a *relative*
jump, and a special workspace's id is negative — `workspace -98` walks back 98
workspaces and lands on 1. Measured: it returns `ok` while doing the wrong
thing. Nor can a special be reached by name; `focus({workspace =
"special:magic"})` is accepted and does nothing, populated or not. What works is
focusing a window *inside* it, which reveals it — so a special node dispatches
its first leaf, and a special only appears in the tree when it has one.
`HyprlandToplevel.address` carries no `0x`, which the dispatcher wants, so the
request puts it back.
**Breaks** *Silently, in the direction that looks like a working picker.*
Collapsing the special case back to the id gives a click that jumps to
workspace 1 and reports success.

## `quickshell/_qml/popups/Switcher.qml` — two Hyprland models had to be measured

**Why** `Hyprland.toplevels` is empty until `refreshToplevels()` runs, so the
overlay refreshes on open; and `HyprlandToplevel.activated` stays false until a
focus event *after* startup, so the current-window marker compares
`ToplevelManager.activeToplevel`, which is populated and survives the overlay
taking exclusive keyboard focus.
**Breaks** *Silently, both.* Without the refresh a shell that has seen no window
open draws an empty tree; reading `activated` draws one where nothing is ever
marked current.

## `quickshell/_qml/popups/Switcher.qml` — where the selection starts, and what Enter does there

**Why** A bare open is an alt-tab, so the selection starts on the window whose
`focusHistoryID` is 1 — the one focused before this one — and a query starts on
the first matching *leaf*. Both exist because `FilterList` otherwise selects row
0, which is always a workspace header: tap-tab-Enter folded workspace 1, and
searching a window name navigated to its workspace instead, landing on that
workspace's most recent window rather than the match. Enter on an occupied node
folds it rather than navigating, since every leaf already reaches its own
workspace; an empty node navigates, having nothing to fold. Under a query the
tree is force-expanded, so Enter navigates there too rather than being a key
that visibly does nothing.
**Breaks** The search case is invisible on a one-window workspace, where
navigating to the workspace happens to focus the matched window anyway.

## `quickshell/_qml/popups/Switcher.qml` — the list must not move under the user

**Why** `groups` is a binding, so every property it touches is a reason to
rebuild the tree and reset the selection. Titles are therefore read in
`rowsFor`, at filter time, not stored on the row — a build scrolling in a
terminal would otherwise yank the selection back to the top mid-navigation.
Measured: renaming a window leaves the `groups` revision and the selection
untouched. The hover half of this left when three more popups turned out to
need it — `docs/decisions/quickshell.md#quickshell-hover-guard`.
**Breaks** *Silently, and only when a window happens to be busy.* It needs a
second window doing something, so a quiet desktop never shows it.

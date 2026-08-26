# Keyboards

External keyboards and the system-level input plumbing they need.

<a id="k8-windows-toggle-keyd"></a>
## `keychron.nix` — the K8 stays in Windows mode; keyd swaps the modifiers

**Why** The non-QMK K8 cannot be reflashed, and its Mac toggle replaces PrtSc
with a firmware macro emitting the literal chord Meta+Shift+4 — byte-identical
to the move-to-workspace-4 bind, so no software layer can tell the screenshot
key from the shortcut. Windows mode keeps real keycodes for the whole PrtSc
cluster; keyd supplies the macOS modifier placement instead, scoped to the
K8's ID (`05ac:024f`) so the QMK board (vendor `3434`) and internal keyboards
keep their layout — in TTYs and under both compositors, unlike a seat-global
XKB option. That ID is Apple's, spoofed by the firmware, which is why
`hid_apple` binds the K8 and defaults its F-row to media-first (`fnmode=3`
auto); `fnmode=2` puts F1–F12 first, Fn+F for media.
**Breaks** Flipping the physical toggle to Mac silently turns PrtSc into
move-to-workspace-4. Dropping `fnmode=2` reverts the F-row to media keys.
Widening or removing `ids` swaps Alt and Super on every keyboard on the seat.

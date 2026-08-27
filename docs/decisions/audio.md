# Audio

PipeWire, and what Bluetooth must enable in BlueZ to feed it.

<a id="le-audio"></a>
## `bluetooth.nix` — LE Audio rides two BlueZ experimental gates

**Why** LE Audio (BAP over ISO channels) needs bluetoothd's experimental
D-Bus interfaces (`Experimental`) and the kernel ISO-socket feature, which
BlueZ gates behind `KernelExperimental`. The bare UUID is BlueZ's ISO-socket
feature identifier — listing it enables only that feature, where `true`
would flip every kernel-experimental flag at once. WirePlumber's default
`bluez5.roles` already includes `bap_sink`/`bap_source` and nixpkgs PipeWire
ships LC3, so nothing is pinned on the PipeWire side.
**Breaks** Silently. Drop either key and LE Audio headsets still pair — as
classic BR/EDR, without LC3. The only symptom is the missing BAP profile in
`wpctl status`.
**Also** A dual-mode headset paired before this change stays on its old
transport; forget and re-pair to negotiate LE Audio. When BlueZ stabilises
LE Audio, delete both settings and this entry in the same commit.

<a id="mpris-proxy"></a>
## `bluetooth.nix` — mpris-proxy registers players with bluetoothd

**Why** Headset buttons already reach the compositors as AVRCP uinput key
events, but two-way playback status needs a player registered with
bluetoothd: the WH-1000XM wear-detection pause keys off it, and LE Audio's
MCP replaces AVRCP with no uinput fallback. mpris-proxy bridges MPRIS
players into BlueZ's player API.
**Breaks** Quietly: buttons keep working over classic AVRCP via the
compositor binds; take-off-to-pause and LE Audio media control stop.
**Also** If one press ever toggles play-pause twice, this proxy and the
compositor bind are double-handling the same press — disable one.

<a id="media-keys-ipc"></a>
## `binds.nix` — the media keys ask the shell, not playerctl

**Why** The bar shows one player and the keys must act on that one. Bare
`playerctl` picks its own target when several MPRIS players are registered, so
a key could pause Firefox while the bar showed mpv. The binds now call
`qs ipc call media …`, which lands in the same `MediaService` the bar reads —
the choice of player is made once, in the shell. `locked = true` still holds:
the IPC socket answers over the lock screen just as playerctl did.
**Breaks** Loudly, and only for the whole namespace at once. A Hyprland host
that does not take `quickshell` sets nothing, so `lib.optionals` emits no media
binds at all rather than binds that do nothing. If the shell is dead the keys
are dead — playerctl did not need it running. `playerctl` stays installed for
CLI use, and dwl binds it independently.
**Also** [#mpris-proxy](#mpris-proxy) still applies. Routing through the shell
replaced the playerctl handler; it did not add a second one.

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

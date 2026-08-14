# Gaming

<a id="proton-compat-path"></a>
## `proton.nix` — `extraCompatPackages`, not a path plus a fetcher

**Why** `programs.steam.package` carries an `apply` that derives
`STEAM_EXTRA_COMPAT_TOOLS_PATHS` from `extraCompatPackages` and injects it into
the FHS wrapper's own environment. Setting that variable by hand duplicated the
module and aimed it at `~/.steam/root/compatibilitytools.d` — mutable state
outside the store, filled by `protonup-ng` at runtime and invisible to a
rebuild.
**Breaks** The Proton-GE version is now whichever one nixpkgs carries, not one
chosen on demand. A title needing a specific build gets it by being added to
`extraCompatPackages`, not by reaching for `protonup`.
**Also** `programs.steam.protontricks.enable` is the right lever for
protontricks rather than `pkgs.protontricks` in a package list — the module
overrides the package so it inherits the same `extraCompatPaths`, which a bare
package does not get.

<a id="ntsync-module"></a>
## `proton.nix` — `ntsync` is loaded, not built

**Why** `CONFIG_NTSYNC=m` already in stock `linuxPackages_latest`. The
in-kernel synchronisation primitive that replaces esync/fsync is compiled and
simply not autoloaded, so `/dev/ntsync` never appears and nothing asks for it.
Loading the module is the whole of the change; no kernel rebuild is involved.
**Breaks** Silently. Without the device node Proton falls back to esync/fsync
and reports nothing — `PROTON_LOG=1` is the only way to see which path a title
actually took.
**Also** Having the node does not oblige Proton to use it; recent builds detect
it, and `PROTON_USE_NTSYNC=1` forces it per-title.

<a id="scx-package"></a>
## `scx.nix` — `rustscheds`, not the default `scx.full`

**Why** `services.scx.package` defaults to `pkgs.scx.full`, which has no
substitute in this pin and pulls `scx_cscheds` in behind it for schedulers
nothing here names. `rustscheds` is cached and its `passthru.schedulers` still
carries `scx_lavd`, which is the one built for gaming workloads — it targets
latency spikes and 1% lows rather than throughput.
**Breaks** `services.scx.scheduler` is typed `enum cfg.package.schedulers`, so
narrowing the package narrows the set of legal names with it. Reaching for a C
scheduler later is an eval error naming the valid ones, not a silent fallback.
**Also** The daemon runs from `multi-user.target`, not per-game. `scx-loader`
driven by gamemode's `custom.start`/`custom.end` is the per-game alternative,
at the cost of more moving parts.

<a id="gamemode-governor"></a>
## `gamemode.nix` — renice only, and the governor stays with PPD

**Why** `renice` is the one general setting gamemode does not already default
to; `inhibit_screensaver` is on, `softrealtime` needs SCHED_ISO that no
upstream kernel ships, and `powerManagement.cpuFreqGovernor = "performance"`
would lose anyway — `power-profiles-daemon` is in `core`, owns the governor and
the EPP, and rewrites both on every profile change. gamemode drives the
governor itself through its pkexec'd `cpugovctl`, scoped to the game.
**Breaks** Silently, in the direction of doing nothing. The two power
mechanisms have no NixOS assertion between them, so a governor set beside PPD
looks applied and is not. Forcing it means dropping PPD, not adding the option
next to it.
**Also** The GPU block is left out on purpose: nixpkgs' own example carries a
hardware-damage warning, and `nv_powermizer_mode` reaches the card through
nvidia-settings, which is inert under Wayland. `users.groups.gamemode` is
created by the module and read by nothing — renice comes from the
`cap_sys_nice` wrapper on gamemoded (`enableRenice`, default true), so adding
the user to that group would be cargo.

<a id="gamescope-wrapper"></a>
## `gamescope.nix` — `capSysNice` moves the binary

**Why** `--rt` asks for realtime scheduling and needs CAP_SYS_NICE to get it;
`capSysNice` is what grants it. `enable` is left to the steam module's
`mkDefault` off `gamescopeSession`, so it is not restated here.
**Breaks** Setting it takes gamescope *out* of `environment.systemPackages` —
the module reads `mkIf (!cfg.capSysNice)` — leaving only the setcap wrapper in
`/run/wrappers/bin`. That is on PATH, so a bare `gamescope` still resolves, but
anything holding a store path from `pkgs.gamescope` gets neither the capability
nor the args.
**Also** `--adaptive-sync` is a request, not an assertion — gamescope enables
variable refresh only where the output supports it. The args do survive the
capability wrapper:
`security.wrappers.gamescope.source` points at the makeWrapper output rather
than the raw package. gamescope on NVIDIA is the most fragile piece in this
stack — if the Steam session stops starting, turn this off first.

<a id="dualsense-no-driver"></a>
## `dualsense.nix` — a tool, not a driver

**Why** `hid-playstation` has been in-tree since 6.2, so the DualSense already
works as a gamepad with nothing declared. `dualsensectl` only adds what the
kernel does not expose: battery, LED, microphone and adaptive-trigger control.
It is a user-facing CLI, so it goes to `homeManager` (CLAUDE.md §6).
**Breaks** Nothing here, but the reason there is no udev rule is worth
recording: `dualsensectl` talks over hidraw, and `programs.steam` sets
`hardware.steam-hardware.enable = true` unconditionally, which pulls in
`steam-devices-udev-rules` and grants that access. Removing Steam would take
the rules with it.
**Also** `hardware.xone` was considered and rejected — it drives the Xbox
Wireless Dongle, and enabling it blacklists `mt76x2u`, a MediaTek Wi-Fi
driver, on a host that cannot be tested from here.

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

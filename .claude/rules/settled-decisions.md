---
paths: "modules/powermenu/**,modules/bar/**,modules/dwl/**,modules/hyprland/**,modules/terminal/**,statix.toml"
---

# Settled decisions — do not re-propose

These shapes were argued to a conclusion. Changing one is a new decision the
human makes, not a cleanup you offer.

- **Quickshell's shape is settled.** `quickshell` and `wleave` are separate
  aspects, `aspectRequires.quickshell = ["hyprland"]` rejects dwl hosts, the
  Hyprland binds drive it over `qs ipc call` through the `bar.toggle` /
  `launcher` / `clipboard.history` / `wallpaperMenu.command` intents, and
  `walker` is its own aspect that no host currently takes. Waybar is retired.
- **Quickshell never joins the security surface.** No `WlSessionLock`, ever —
  locking is `lock.command` (`loginctl lock-session`, hypridle runs hyprlock),
  wallpaper switching is hyprpaper IPC plus the cache symlink, and idle
  inhibition is the Wayland protocol hypridle honours. hyprlock, hypridle and
  hyprpaper stay in charge.
- **dwl's bar is `dwl-bar`; its shape is settled.** `dwl/dwl.nix` declares `dwl.bar`
  in `homeManager.dwl`; `bar/dwl-bar.nix` sets it and declares
  `aspectRequires.dwl-bar = ["dwl"]`. Silent failure by construction — a dwl
  host without `dwl-bar` builds a working bar-less dwl.
- **The terminal is an aspect, and its namespace file names no terminal.**
  `terminal/terminal.nix` declares `terminal.*` in `core` and sets `transientArgv` from
  `hyprland` through `appIdArgv`; `terminal/{foot,alacritty,ghostty,kitty}.nix`
  implement it. `desktopFile` and `binary` carry no default on purpose — they
  are the only scalars, and so the only thing that rejects a host taking two
  terminals. Do not give them defaults, and do not fold the namespace back into
  an implementation.
- **ghostty's `scrollback-limit` stays unset.** It counts **bytes**, not lines,
  and defaults to 10 MB; the `50000` this config was revived from reads like
  foot's 10 000 lines and is in fact 50 KB.
  `docs/decisions/terminal.md#ghostty-scrollback`.
- **Deliberately deferred — do not propose unasked:** a dwl host taking
  `walker` (four blockers in git history).
- **`statix.toml` disables `repeated_keys`, and it stays disabled.** The rule
  flags the best exemplar files and untouchable hardware configs. Do not
  re-enable.
- **The five ex-`common-packages` tools stay in `nixos`.** Deliberately
  accepted, not a divergence — the move to `home.packages` would be a
  behavioural change. Do not "fix" it.

Rationale for each lives in git history. Cite a commit hash, never a plan
filename.

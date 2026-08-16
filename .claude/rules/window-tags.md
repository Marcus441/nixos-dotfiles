---
paths: "modules/hyprland/rules.nix,modules/dwl/dwl.nix,modules/hyprland/hyprland.nix"
---

# `windowTags`: many setters, one reader

`windowTags.<tag> = [<class regex>]` in `core`, appended to by every file that
installs a window, read by `hyprland/rules.nix`. The namespace is in `core`
because `core` files set it and would otherwise fail on swift5. A dwl host
carries the value with no reader — measured: swift5 builds byte-identical.

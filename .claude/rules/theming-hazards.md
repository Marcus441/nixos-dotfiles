---
paths: "**/terminal/*.nix,**/qt.nix,**/bat.nix,**/yazi*.nix,**/gtk.nix,**/zathura.nix,**/*theme*.nix,**/colors.nix,modules/quickshell/**,modules/firefox/**"
---

# Theming hazards — colours and syntax themes

- **ANSI carries upstream's table, so it reaches into base24.** `desktop.ansi`
  reproduces kanagawa.nvim's `dragon.term` exactly, which means it reads
  `desktop.colors` and not `desktop.colors16`: slot 0 is base11 and the brights
  9–14 are base12–base17. Do not "restore" a slot convention over it — the
  upstream table is the authority, and matching it is checkable against the
  files in `extras/`. `desktop.colors16` remains the honest type for the
  consumers that genuinely cannot reach an extension slot. The reason `bat.nix`
  and `filemanager/yazi-style.nix` share `desktop.syntaxTheme` is unchanged:
  syntect takes a tmTheme, not ANSI.
- **base03 is read as a background, so it cannot hold a light value.**
  `tmtheme.nix` uses it for `lineHighlight`. ANSI 8's `#a6a69c` lives in base04
  for that reason — see `docs/decisions/theming.md#colors-neutrals`. Check
  whether a slot is ever a background before rebalancing the neutrals.
- **`desktop.ansi` is positional, like qt5ct's role list.** The index *is* the
  slot number, and each terminal renders it into its own vocabulary
  (`regular0`/`bright0`, `colors.normal.black`, `color0`, `palette = "0=…"`).
  Reordering the list silently reassigns every colour in every terminal at
  once. Slots 16 and 17 are deliberately outside it — the 256-cube trick that
  carries base09 and base0F — so each terminal reads `colors16` for those.
- **`reset` is a value that only survives being drawn.** yazi's status bar
  reads colours back and transposes them — `status.lua` draws `style.alt:bg()`
  as a *foreground*, where a `reset` renders as a base05 bar through the middle
  of the bar. Use `base00` (the terminal background, so it renders as
  nothing) wherever a background is read back. Check whether anything reads a
  colour back before choosing one.
- **The leading `#` in `desktop.colors` is load-bearing.** Consumers either
  strip it or paste it raw, so a value without one is silently right in some
  files and silently wrong in others. The option type makes it a build failure.
- **A partial theme merges onto the preset; a list replaces it.** yazi's theme
  overrides only what the preset gets wrong, but its `icon` rules replace the
  preset's 14 named-folder rules wholesale.
- **A yazi popup fills only if its contents cover every cell.** Every popup
  draws `Clear` — ratatui's, so the terminal default — then an *unstyled*
  `Block`, so no key fills an interior directly. `input` and `cmp` still come
  out solid, because `border` + `title` + `value` reach all three of the
  input's rows and `cmp` sizes itself to `items.len() + 2`; `confirm`, `tasks`,
  `spot` and `notify` have no such cover and stay frames. Do not generalise
  from either half — check which keys reach which cells.
  `docs/decisions/terminal.md#yazi-blocks`.
- **A yazi `bg` needs `reversed = false` beside it.** The merge is partial, so
  the preset's `reversed = true` on `indicator.parent`/`current`, `cmp.active`,
  `input.selected` and `help.hovered` survives and swaps the `bg` into the
  foreground — a coloured-text row instead of a bar.
- **Colour formats are per-consumer, and none of them are interchangeable.**
  Qt wants ARGB (`#aarrggbb`) and no alpha comes from the palette; girara
  (zathura) parses through `gdk_rgba_parse`, which takes `#rrggbbaa`; dwl's
  colour tables want `0xrrggbbff`; hyprlang wants `rgb(rrggbb)` /
  `rgba(rrggbbaa)`.
- **`#` opens a comment in hyprlang, so a bare `#rrggbb` never reaches
  hyprlock.** Colours go through `rgb(…)`. The same rule bites pango markup in
  a hyprlock text field, where a hex colour has to be written `##rrggbb` —
  which is why `lock/hyprlock.nix` mutes the date with a `color` key on its own
  label rather than a `<span foreground=…>` inside one.
- **hyprlock ignores config keys it does not know, and says so only on
  stderr.** Parse-check a generated config without locking the screen:
  `WAYLAND_DISPLAY=nonexistent hyprlock -c <path>` prints every
  `config option <x> does not exist` and then dies on the missing compositor.
  This is how `general:grace`, `general:no_fade_in` and
  `general:disable_loading_bar` were found to be dead in 0.9.6 — `grace` and
  `no_fade_in` became the CLI flags `--grace` / `--no-fade-in`.

## Toolkit theming traps

- **`platformTheme.name = "adwaita"` is not a platform theme.** It installs
  qadwaitadecorations — Wayland decorations — while still exporting
  `QT_QPA_PLATFORMTHEME=adwaita`, which resolves to no plugin, so Qt apps
  silently take no icon theme and no font. Use `qtct`. Do not set
  `qt.style.name`: it exports `QT_STYLE_OVERRIDE`, which wins over the qt5ct/
  qt6ct files and splits the decision across two places.
- **qt5ct/qt6ct write the 21 `QPalette::ColorRole` roles as one positional
  list.** The order *is* the format. Reordering silently reassigns every
  colour.
- **QSettings splits an unquoted value on commas.** The quotes around the
  `QFont::toString` 10-field form are what stop qt6ct receiving a
  `QStringList` instead of a font.
- **libadwaita colour names need adw-gtk3-dark.** Stock Adwaita-dark's GTK3
  sheet imports `gtk-contained-dark.css`, which uses the GTK3-era names
  (`theme_bg_color`, `borders`, …) and shares none of libadwaita's — so under
  it a libadwaita palette is inert for GTK3, which is most of the fleet's apps.

## Where the options are declared

- `modules/theme/colors.nix` — `desktop.colors` (base24, hex),
  `desktop.colors16` (the `base0*` subset, what the hex-only TUI consumers read)
  and `desktop.ansi` (upstream's dragon terminal table in slot order, what the
  terminals render).
- `modules/theme/tmtheme.nix` — provider/consumer split: declares `desktop.syntaxTheme`
  in `core`, read by `bat.nix` and `filemanager/yazi-style.nix`.
- `modules/theme/font.nix` — the options are `core`; `terminalSize` comes from
  the host record, because it is a property of the panel and not of the theme,
  while `size` is the desktop UI (shell) size with a plain default.

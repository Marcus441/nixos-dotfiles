---
paths: "**/foot.nix,**/qt.nix,**/bat.nix,**/yazi.nix,**/gtk.nix,**/zathura.nix,**/*theme*.nix,**/colors.nix"
---

# Theming hazards — colours and syntax themes

- **ANSI carries base16; base24 is only reachable as hex.** `foot.nix` renders
  the standard base16 slot mapping from `desktop.colors16` (the `base0*` subset
  of `desktop.colors`), so a program asking for *the base16 theme* now gets
  what it asserts — ANSI 9 is base09. The corollary is that `base10`–`base17`
  cannot travel through ANSI at all: a consumer wanting one reads
  `desktop.colors` and hands over hex, which is why `qt.nix` does. The reason
  `bat.nix` and `filemanager/yazi.nix` share `desktop.syntaxTheme` is
  unchanged: syntect takes a tmTheme, not ANSI.
- **`reset` is a value that only survives being drawn.** yazi's status bar
  reads colours back and transposes them — `status.lua` draws `style.alt:bg()`
  as a *foreground*, where a `reset` renders as a base05 bar through the middle
  of the bar. Use `base00` (foot's terminal background, so it renders as
  nothing) wherever a background is read back. Check whether anything reads a
  colour back before choosing one.
- **The leading `#` in `desktop.colors` is load-bearing.** Consumers either
  strip it or paste it raw, so a value without one is silently right in some
  files and silently wrong in others. The option type makes it a build failure.
- **A partial theme merges onto the preset; a list replaces it.** yazi's theme
  overrides only what the preset gets wrong, but its `icon` rules replace the
  preset's 14 named-folder rules wholesale.
- **Colour formats are per-consumer, and none of them are interchangeable.**
  Qt wants ARGB (`#aarrggbb`) and no alpha comes from the palette; girara
  (zathura) parses through `gdk_rgba_parse`, which takes `#rrggbbaa`; dwl's
  colour tables want `0xrrggbbff`.

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

- `modules/theme/colors.nix` — `desktop.colors` (base24, hex) and
  `desktop.colors16` (the `base0*` subset, what ANSI consumers read).
- `modules/theme/tmtheme.nix` — provider/consumer split: declares `desktop.syntaxTheme`
  in `core`, read by `bat.nix` and `yazi.nix`.
- `modules/theme/font.nix` — the option is `core`; point size comes from the
  host record, because it is a property of the panel and not of the theme.

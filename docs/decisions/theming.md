# Theming

Colour, fonts, and the two toolkits.

<a id="colors-hash"></a>
## `theme/colors.nix` — the leading `#` is part of the value

**Why** Consumers either strip it or paste it raw.
**Breaks** *Silently.* A value without one is right in some files and wrong in
others. The option type makes it a build failure instead.

<a id="tmtheme"></a>
## `theme/tmtheme.nix` — the hex escape hatch

**Why** bat and yazi's preview highlight with syntect, which takes a tmTheme and
not ANSI. One theme, so a file looks the same in both.

<a id="bat"></a>
## `cli/bat.nix` — not bat's built-in `base16`

**Why** That one renders through ANSI, so it carries whichever sixteen colours
the terminal holds — and a pager reached through `less` is not always ours.
**Breaks** *Silently.* Colours drift with whatever terminal launched it.

<a id="qt-platformtheme"></a>
## `theme/qt.nix` — `platformTheme.name = "qtct"`

**Why** `"adwaita"` installs qadwaitadecorations — Wayland *decorations*, not a
QPA platform theme — while still exporting `QT_QPA_PLATFORMTHEME=adwaita`,
which resolves to no plugin.
**Breaks** *Silently.* Qt apps take no icon theme and no font. No error.
**Also** Never set `qt.style.name`: it exports `QT_STYLE_OVERRIDE`, which wins
over these files.

<a id="qt-roleorder"></a>
## `theme/qt.nix` — `roleOrder` is a format, not a preference

**Why** qt5ct/qt6ct write the 21 `QPalette::ColorRole` roles as one positional
list.
**Breaks** *Silently.* Reordering reassigns every colour.

<a id="qt-font"></a>
## `theme/qt.nix` — the quotes in `qfont` are load-bearing

**Why** `QFont::toString`'s legacy 10-field form, which Qt 6 still parses.
**Breaks** *Silently.* QSettings splits an unquoted value on commas and hands
qt6ct a `QStringList` instead of a font.

<a id="gtk-adw"></a>
## `theme/gtk.nix` — libadwaita names need adw-gtk3-dark

**Why** `paletteCss` uses libadwaita's colour names.
**Breaks** *Silently.* Stock Adwaita-dark's GTK3 sheet uses the GTK3-era names
and shares none of them, so every line is inert for GTK3 — most of the fleet's
apps.

<a id="cursor"></a>
## `theme/cursor.nix` — DMZ-Black

**Why** The regimes disagreed (swift5 DMZ-Black, stylix hosts Adwaita, both
24px). DMZ-Black wins because a file in this repo chose it; Adwaita came with
the generator.

## `theme/font.nix` — option and packages both in `core`

**Why** The option is what other files read; the packages put fonts on disk.
Both belong to every host. Point size comes from the host record, being a
property of the panel and not the theme.

<a id="zathura-alpha"></a>
## `media/zathura.nix` — `#rrggbbaa`

**Why** girara parses through `gdk_rgba_parse`, which takes `#rrggbbaa`, so the
highlights get transparency without a second colour format.

<a id="lazygit"></a>
## `lazygit.nix` — `selectedLineBgColor = ["default"]`

**Why** `default` keeps the terminal's own background, so the cursor line does
not fight foot's.

<a id="walker-style"></a>
## `walker.nix` — the launcher names no theme

**Why** Setting `theme` at all overrides `services.walker.settings.theme` with
its name, so `walker-style.nix` owns it alone.

## `mako.nix` — notifications are a capability, not a theme

**Why** The daemon lived in `palette` and `stylix`.
**Breaks** A dwl host taking neither got no notifications at all, while
`dwl.nix`'s autostart still invoked `mako` by bare name.

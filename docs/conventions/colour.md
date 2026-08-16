# Colour

One source, four renderings. Declared in `modules/theme/`.

| Option | What it is | Who reads it |
| --- | --- | --- |
| `desktop.colors` | full base24 Kanagawa Dragon, hex, leading `#` | anything needing an extension slot (base10–base17) |
| `desktop.colors16` | the `base0*` subset — exactly the low sixteen | anything speaking **ANSI** |
| `desktop.colorsRgb` | `colors16` as `r;g;b` | anything writing a 24-bit SGR sequence by hand: the bash prompt, the pager colours |
| `desktop.syntaxTheme` | a tmTheme | syntect: `bat`, yazi's preview |

**Read `colors16` unless you specifically need a base24 slot.** ANSI carries
base16 only; base10–base17 cannot travel through it at all.

Two rules that are easy to get backwards:

- **The leading `#` is part of the value.** Consumers either strip it or paste it
  raw, so a value without one is silently right in some files and wrong in
  others. The option type makes it a build failure.
- **`reset` only survives being drawn.** Where a colour is read back and
  transposed — yazi's `status.lua` draws a background as a foreground — use
  `base00`, which is the terminal background and so renders as nothing.

<a id="colour-formats"></a>
## Per-consumer formats

Not interchangeable: Qt wants `#aarrggbb`, girara
(zathura) wants `#rrggbbaa`, dwl's colour tables want `0xrrggbbff`, and
hyprlang (hyprlock) wants `rgb(rrggbb)` or `rgba(rrggbbaa)` — it rejects a bare
`#rrggbb`, because `#` opens a comment. `lock/hyprlock.nix` therefore maps the
palette through `rgb(…)` rather than stripping the `#` and pasting it.

Full traps: `.claude/rules/theming-hazards.md`.

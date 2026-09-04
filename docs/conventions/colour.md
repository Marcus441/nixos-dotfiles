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

<a id="shell-roles"></a>
## `desktop.roles` — what a slot means to the shell

**Why** Every quickshell file named a palette slot, so each popup re-decided
what "muted" meant and the four of them drifted apart.

| Role | Slot | |
| --- | --- | --- |
| `textPrimary` | base05 | text and icons at full strength |
| `textSecondary` | base04 | the same, one step down |
| `textMuted` | base03 | idle icons, hints, the scrollbar handle |
| `accent` | base0D | the active, selected or playing state |
| `selection` | base02 | row highlights, and a meter's track |
| `chrome` | base01 | the bar, and the popup surfaces on it |
| `card` | base10 | a modal's own surface, above the scrim |
| `scrim` | — | `#66000000`, the dimmed backdrop behind a modal |

`textSecondary` is base04 and not base03 because base03 cannot hold a light
value — `tmtheme.nix` reads it as `lineHighlight`, a background. base04 is the
lighter neutral, and carries ANSI 8. Rebalancing the neutrals moves both.
Declared in the `quickshell` aspect, not `core`: nothing else has a use for
`card` or `scrim`. The six hue slots stay raw — base08 means red wherever it
appears, and a role would only rename it.

**Breaks** *Silently.* `scrim` is eight hex digits, which Qt reads as
`#aarrggbb` ([formats](#colour-formats)). Written `#rrggbbaa` it is an
almost-opaque black, so the modal loses its backdrop rather than erroring.

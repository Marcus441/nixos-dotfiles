# Bar glyphs

Every Waybar module that shows a glyph beside a value aims for the **same
optical gap between the two, ~3.4px at the bar's 12px**. That gap is not one
thing: it is the glyph's own right side bearing plus whatever whitespace the
format string adds. Getting it wrong is invisible in the source and obvious on
screen.

In `Symbols Nerd Font Mono` every advance is 2048 units, but the ink inside
that cell is not. Measured at 12px:

| glyph | used by | right bearing | whitespace in format | gap |
| --- | --- | --- | --- | --- |
| `md-memory` U+F035B | `cpu` | 0.00px | `U+0020` 3.38px | 3.38px |
| `fa-memory` U+EFC5 | `memory` | 0.00px | `U+0020` 3.38px | 3.38px |
| `md-harddisk` U+F02CA | `disk` | 1.18px | **`U+2009` 2.18px** | 3.36px |
| `md-thermometer_*` | `custom/cputemp` | 3.00px | **none** | 3.00px |
| `md-weather_*` | `custom/weather` | 0.00px | `U+0020` 3.38px | 3.38px |

So there are three cases, and which one applies is a property of the glyph, not
a style choice:

- **Bearing ~0** — the glyph fills its cell, so the format supplies an ordinary
  space. `cpu`, `memory`, `weather`.
- **Bearing ~3px** — the glyph already carries the gap, so the format adds
  **nothing**. `cputemp`. Adding a space here doubles it to 6.4px, which is
  what the module used to look like.
- **Bearing in between** — no ordinary space fits. `disk` is 1.18px and takes a
  **thin space, `U+2009`**, to land on 3.36px.

**The thin space in `storage.nix` is deliberate and it is invisible.** It is
there because all three hard-drive glyphs in the font (`md-harddisk`,
`md-micro_sd`, `md-sd`) measure 1.18px and the full-width alternatives are all
databases and floppies — the metric was the only thing left to change. Do not
"tidy" it into a normal space.

Two consequences worth knowing before changing a glyph:

- **A ramp must be bearing-uniform, or the gap moves as the value crosses a
  band.** `md-fire_alert` (0.00px) once sat on top of the three thermometers
  (3.00px), so passing 90°C tightened the gap by 3px. No `md` fire or alert
  glyph shares the thermometers' bearings, which is why `.critical` is carried
  by colour alone and the ramp is three glyphs, not four. `fa-temperature_empty`
  through `_full` are uniform at 2.62px if a five-band ramp is ever wanted.
- **Glyph-only modules are exempt.** `battery`, `bluetooth`, `network`,
  `pulseaudio`, `idle_inhibitor`, `custom/power` render a glyph and nothing
  else, so no internal gap exists. Their inter-module spacing is
  `margin: 0 6px` in `waybar-style.nix`, which is a different quantity.

Tooltips are exempt too: they have their own font context and nothing to line
up against. `weather.nix`'s tooltip still mixes `weather-*` (U+E350, U+E373)
with `md-*` (U+F059D), where the bar row is all `md-*`.

Measure, do not eyeball — `fontTools` reports the bearing:

```python
from fontTools.ttLib import TTFont
from fontTools.pens.boundsPen import BoundsPen
f = TTFont(path); upem = f['head'].unitsPerEm; gs = f.getGlyphSet()
g = next(t.cmap[cp] for t in f['cmap'].tables if cp in t.cmap)
adv, _ = f['hmtx'][g]
bp = BoundsPen(gs); gs[g].draw(bp)
rsb_px = (adv - bp.bounds[2]) * 12 / upem
```

# docs/

Why the config is the way it is. The `.nix` files say what it is.

```
conventions/   patterns that recur across many files
  intents.md     option in core, implementation per session
  placement.md   which aspect, which class
  colour.md      one palette, four renderings

decisions/     why one file made its call, grouped by area
  wiring.md            generator, host record, aspect options
  sessions.md          dwl, Hyprland, the bars
  shells.md            bash, zsh, and which host logs into which
  terminal.md          the four terminals and the TUIs that carry one
  theming.md           colour, fonts, the two toolkits
  placement.md         why a file is not in the obvious aspect
  display-and-boot.md  monitors, hyprlock, boot
  xdg.md               which app state leaves $HOME, and which stays
```

Most entries are three lines — **Why** the value is what it is, **Breaks** what
goes wrong if you change it, and **Also** where there is a related trap.
**Breaks** is the line worth reading.

## Finding the reason for a line

Files carry no comments except a pointer, at the 88 values where changing them
breaks something non-obviously:

```nix
# load-bearing: docs/decisions/theming.md#qt-platformtheme
platformTheme.name = "qtct";
```

The 34 whose **Breaks** line says *silently* are the sharp end — they fail with
no error anywhere, so the pointer is the only warning.

## Where else things live

- **`CLAUDE.md`** — the invariants. What must stay true.
- **`.claude/rules/*.md`** — hazards and mechanics, loaded automatically by file
  path. `hazards-detail.md`, `theming-hazards.md`,
  `structural-verification.md`.
- **`docs/`** — the rationale.

## Keeping these honest

**A decision changes ⇒ its entry changes, in the same commit.** A register that
drifts is worse than none. Don't restate the code: an entry that survives *"a
careful reader would already know this from the file"* is the only kind worth
adding. Finished plans go to git history (`CLAUDE.md` §10).

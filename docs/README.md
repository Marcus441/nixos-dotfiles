# docs/

Why the config is the way it is. The `.nix` files say what it is.

```
inventory.md   generated — hosts, aspects, classes, aspect dependencies

conventions/   patterns that recur across many files
  intents.md     option in core, implementation per session
  placement.md   which aspect, which class
  colour.md      one palette, four renderings

decisions/     why one file made its call, grouped by area
  wiring.md            generator, host record, aspect options
  hosts.md             machine facts that need a reason
  sessions.md          dwl, Hyprland, the bars
  shells.md            bash, zsh, and which host logs into which
  terminal.md          the four terminals and the keys they intercept
  tui.md               yazi, thunar, btop, impala, herdr, claude-code
  theming.md           colour, fonts, the two toolkits
  placement.md         why a file is not in the obvious aspect
  display-and-boot.md  monitors, hyprlock, boot
  gaming.md            Steam, Proton, the scheduler, the GPU
  audio.md             PipeWire, BlueZ, and what LE Audio switches on
  xdg.md               which app state leaves $HOME, and which stays
```

Each entry is **Why** the value is what it is and **Breaks** what goes wrong if
you change it, with an occasional **Also** for a related trap. **Breaks** is the
line worth reading, and the ones that say *silently* are the sharp end — they
fail with no error anywhere, so the entry is the only warning.

## Finding the reason for a line

Files carry no comments except a pointer, at the values where changing them
breaks something non-obviously:

```nix
# load-bearing: docs/decisions/theming.md#qt-platformtheme
platformTheme.name = "qtct";
```

`grep -rn 'load-bearing:' modules/` lists every one; `docs/inventory.md` counts
them. Nothing here restates a count in prose — that is what went stale before.

## Keeping these honest

**A decision changes ⇒ its entry changes. Its code is deleted ⇒ its entry is
deleted.** Both halves, in the same commit. `scripts/docs-check.sh` enforces the
second by failing on an anchor nothing points at, and holds each entry to 22
prose lines and each file to 350.

Don't restate the code: an entry that survives *"a careful reader would already
know this from the file"* is the only kind worth adding. Finished plans go to
git history (`AGENTS.md` §11).

## Where else things live

- **`AGENTS.md`** — the invariants, the hazards, and the task-guide table.
  `CLAUDE.md` is a one-line import of it.
- **`.claude/rules/*.md`** — mechanics and hazards, loaded by file path.
- **`docs/`** — the rationale.

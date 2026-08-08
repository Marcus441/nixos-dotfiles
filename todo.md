# todo

Five branches, ordered foundations-first. Each heading is one branch, one PR, squash-merged.
Nothing here is started until the branch above it is merged.

## Protocol — run at the end of every branch, before opening the PR

1. `./scripts/verify.sh build` — all six targets. For a branch marked **structural**, run
   `./scripts/verify.sh <base>` instead: it compares out-paths on both trees, and an
   identical path is a stronger result than §10's empty `diff-closures`.
2. Update `CLAUDE.md` with what the branch decided: new aspect, new option namespace, a
   §12 divergence opened or closed, a hazard discovered. Rationale goes in the commit
   message; the *decision* goes in CLAUDE.md.
3. Tick the box here.
4. Squash-merge the PR, `git switch main && git pull`.
5. **Stop and ask for `/clear`** before starting the next branch.

Structural branches (1, 2, 3, 4) go through the `dendritic-reviewer` subagent *before* the
commit — CLAUDE.md §13.

---

## 1. `refactor/feature-dirs` — navigation directories  **structural**  ✅

Foundation: branches 2 and 4 add files that want somewhere to live.

- [x] `CLAUDE.md` §4/§11 rewritten to permit navigation directories, and honest that it
      *widens* the old rule rather than restating it. The dropped clause ("the name would
      be a bad aspect name") ruled out the one directory worth having.
- [x] `modules/filemanager/` ← `thunar.nix`, `yazi.nix`. Spans `thunar` (both classes) and
      `apps` — two aspects some host declines — plus the `core` `fileManager.command`
      intent it is named after.
- [x] **`modules/bar/` deferred to branch 2.** All three `waybar*` files declare `waybar`
      alone; the only other membership is a `core` options block, and `core` is universal
      so it does not discriminate. Today the directory is the flat case. It becomes legal
      the moment `dwl-bar.nix` lands beside them. Recorded in §4 as the worked
      counter-example.
- [x] Seven `hyprland-*.nix` left flat — all declare `hyprland` alone, which is exactly
      what §4 says should stay flat and §11 names outright.
- [x] Task 1.2 confirmed as already built: `swift5` takes neither `waybar` nor `wleave`,
      `aspectRequires.waybar = ["hyprland"]` rejects a dwl host, `custom/power` is gated on
      `powerMenu.command`. Recorded in §13 so it is not re-proposed.
- [x] **Measured: 6/6 identical out-paths against `main`** via `./scripts/verify.sh main`,
      which compares store paths directly and so is stronger than §10's `diff-closures`
      block. Independently confirmed by `drvPath` equality.

**Done:** `refactor/feature-dirs`, six targets byte-identical.

---

## 2. `feat/dwl-bar` — the bar patch as its own aspect  **structural**  ✅

Mirrors `waybar`→`hyprland`. Listed under CLAUDE.md §13 "deliberately deferred"; this
branch is the ask that lifts that.

- [x] **`modules/bar/` created in this branch**, carried over from branch 1: the three
      `waybar*.nix` moved in alongside the new `dwl-bar.nix`. With two declining aspects
      (`waybar`, `dwl-bar`) inside, the directory passes §4 — which it did not on its own.
      Moved in its own commit, measured 6/6 identical.
- [x] `modules/bar/dwl-bar.nix`, declaring `flake.modules.homeManager.dwl-bar` and
      `flake.modules.nixos.dwl-bar`, plus `aspectRequires.dwl-bar = ["dwl"];`.
- [x] The `barPatch` fetch and its `fcft`/`libdrm` buildInputs moved into the new file;
      `dwl.nix` declares `dwl.patches` / `dwl.buildInputs` in the `dwl` aspect and builds
      the derivation from them.
- [x] `config.h` is conditional — but on **more** than this list predicted. The patch does
      not only *add* symbols, it replaces them: `bordercolor`/`focuscolor`/`urgentcolor`
      become `colors[][3]`, `#define TAGCOUNT (9)` becomes `tags[]`, and `Button` grows a
      click-region field so the whole array changes shape, not just its rows. Five blocks
      trade on `dwl.bar` rather than four being omitted.
- [x] **The session script trap**, as described: `nixos.dwl` declares `dwl.statusCommand`
      and renders the pipe from it; `nixos.dwl-bar` sets the `date` loop. Empty on an
      unpatched dwl, and the pipe is dropped rather than fed from `/dev/null`.
- [x] `swift5.aspects`: `"dwl-bar"` inserted after `"dwl"`.
- [x] **Measured.** swift5's homeConfiguration is *byte-identical* — a stronger result than
      this list predicted, and it proves the bar-on `config.h` renders unchanged. swift5's
      nixos toplevel differs only in a rewritten comment inside `dwl-session` (empty
      `diff-closures`, command line byte-identical). `gpc` and `UM790pro` identical on both
      classes, so nothing leaked.
- [x] Removing `"dwl-bar"` compiles unpatched dwl-0.8: no `togglebar` bind, upstream
      `Button` array, `TAGCOUNT`, no status pipe. The generator rejects `dwl-bar` without
      `dwl` by name.

**Done:** the bar is an aspect; swift5 builds with it and without it.

---

## 3. `feat/window-tags` — decentralised Hyprland tagging  **structural**

Replaces the one centralised `tag-floating-by-class` regex in `hyprland-rules.nix` with an option
namespace each app's own file appends to. §3's intent/implementation split, applied to
window rules.

- [x] `modules/window-tags.nix` declares in `core`:
      `windowTags = attrsOf (listOf str)` — tag name → list of class regexes.
      `core`, not `hyprland`, so an app file can append without its aspect depending on a
      compositor. A dwl host that sets it and has no reader is inert — measured, swift5 is
      byte-identical on both classes.
- [x] `hyprland-rules.nix` renders `config.windowTags` into the `tag = "+<name>"` rules and
      keeps the behaviour rules (`float`/`center`/`size`) keyed on the tag. One rule per
      regex rather than one alternation: the regexes arrive from separate files, so joining
      them would need a grouping no contributing file can see it needs. `lib.unique` per tag,
      so two files naming the same window emit one rule.
- [x] `filemanager/thunar.nix` appends inside the `thunar` aspect; pavucontrol in `media.nix`
      (`core`, where it is installed), blueman in `bluetooth.nix` — which gains a
      `homeManager.core` block and so becomes the twentieth two-class file in §2 — and
      xdg-desktop-portal-gtk in `hyprland.nix`.
- [x] **Tag kept as `floating-window`, not renamed to `floating`.** A tag name is rendered
      output, which is §3's stated exception to "a bad name is cheap to fix" — renaming would
      change `hyprctl clients`, i.e. this branch's own done-condition.
- [x] `thunar-no-anim` kept with thunar, as a second tag rather than a moved window rule.
      Moving the rule verbatim would have an app aspect writing
      `wayland.windowManager.hyprland.settings`, which is the coupling this branch removes.
- [x] Noted in CLAUDE.md §3 that `dwl.nix`'s `rules[]` is the second implementation this was
      shaped for — and that it would *translate* rather than consume, since dwl matches
      `app_id` by substring and its `tags` are workspace bitmasks.
- [x] **Measured.** `./scripts/verify.sh main`: swift5 identical on both classes, all three
      nixos toplevels identical, `gpc` and `UM790pro` home differ in exactly one file
      (`.config/hypr/hyprland.lua`) with empty `diff-closures`.

Deliberately **not** doing launch-time `hyprctl dispatch tagwindow`: it makes the rule
race the window and only fires for windows *we* spawn. Declarative rules are decentralised
by which file declares them, which is what the request is actually after.

**Done when:** `hyprctl clients` on `UM790pro` shows the same tags on the same windows as
before, and `gpc`'s rendered `hyprland.lua` diff is confined to rule ordering.

---

## 4. `feat/yazi-filemanager` — yazi as an alternative file manager  **structural**

`modules/filemanager/yazi.nix` already exists and is fully themed; it declares `apps` and
sets no `fileManager.command`. This branch gives it the role.

- [ ] Split the file: the program config stays where it is; a new `yazi` aspect sets
      `fileManager.command`. `thunar` and `yazi` then both set the same option, so a host
      taking both is a merge conflict — correct, and the same shape as
      `walker`/`wmenu` under `launcher.argv` (§3).
- [ ] `fileManager.command` must open a terminal: read `config.terminal.command`
      (declared in `foot.nix`) rather than naming foot. `footclient yazi`, with the same
      server-down caveat every other spawn point has.
- [ ] `xdg.mimeApps.defaultApplications."inode/directory"` — **open question**:
      `programs.yazi` ships no `.desktop` file, so this needs a `makeDesktopItem` with
      `Terminal=false` and an `Exec` that spawns the terminal itself. Resolve on the branch;
      if it turns out ugly, leave the mime default unset and say so in CLAUDE.md rather
      than pointing it at a desktop entry that does not exist.
- [ ] No host changes. `gpc` and `UM790pro` keep `thunar`; `yazi` is available for
      `swift5`, which today has no file manager at all.

**Done when:** all six targets build unchanged, and adding `"yazi"` to a host that already
has `"thunar"` fails the build with both filenames named (this is what `deferredModule`
buys — §9).

---

## 5. `feat/base16-tui` — base16 for terminals, base24 for GUI

Widest blast radius, so last. Every terminal colour on every host moves.

- [ ] `modules/colors.nix` gains `desktop.colors16`, `readOnly`, derived as the
      `base00`–`base0F` subset of `desktop.colors`. One source of colour; two renderings.
- [ ] `foot.nix` remaps `colors-dark` to the base16 convention:
      `regular0-7 = base00 08 0B 0A 0D 0E 0C 05`, `bright0-7 = base03 08 0B 0A 0D 0E 0C 07`.
      This is the point of the branch — ANSI 9 becomes base09, which is what every
      base16-aware TUI already assumes.
- [ ] Move the TUI consumers onto `colors16`: `tmux.nix`, `bat.nix`, `filemanager/yazi.nix`,
      `opencode-style.nix`.
- [ ] Leave `gtk.nix`, `qt.nix`, `waybar-style.nix`, `wleave.nix`, `dwl.nix`, `discord.nix`
      and `walker.nix` on the full `desktop.colors`. `qt.nix` reads `base10` for its shadow role and
      `foot`'s old mapping read `base11`–`base17`; those slots only exist in base24.
- [ ] **Retire the §9 hazard.** "ANSI is not free just because foot sets it from the
      palette" exists because base12 sat in slot 9. Once it does not, rewrite that bullet —
      do not delete it, since the *reason* bat and yazi share `desktop.syntaxTheme` is
      unchanged (syntect takes hex, not ANSI).
- [ ] Keep `tmtheme.nix` as-is. It is already rendered from base00–base0F and is already
      correct; switching it to `colors16` is a no-op that would move store paths for
      nothing.
- [ ] **Visual check, not just a build.** Expect terminal brights to lose the base24 punch
      (`base12` red → `base08`). Look at `bat`, `btop`, `lazygit`, `yazi` and `neovim`
      before merging; this is the one branch where a clean build proves very little.

**Done when:** built and *looked at* on `UM790pro`, and CLAUDE.md §9 reflects the new
mapping.

# Refactor Plan: Split the `maximal` aspect

The Dendritic migration is done. `main` is the ex-`dendritic` branch, the
byte-identity baseline is retired, and `../dotfiles-old` is gone. The previous
plan — shell unification, Dendritic migration, typed monitors — is complete and
lives in git history if you need it:

```bash
git log --oneline --all -- REFACTOR.md
git show <sha>:REFACTOR.md
```

This plan addresses what that migration left behind: **`maximal` is not an
aspect, it is three aspects fused together.**

---

## The problem

`maximal` currently means all of:

1. **the Hyprland session** — compositor, hypridle/hyprlock/hyprpaper, waybar,
   the uwsm autostart, the wleave power menu;
2. **the heavy app set** — thunderbird, discord, obs, virt-manager, neovide;
3. **stylix theming**.

A host that wanted Hyprland without Thunderbird, or the app set under a
different compositor, cannot say so. This is the same conflation
`suckless`/`maximal` had before the migration, reproduced one level down.

The visible symptom is the `_` directories. `modules/maximal/_hyprland` is 14
files hidden from import-tree, and it feels like it needs a directory because it
*is* a distinct concern — the directory is standing in for an aspect name it was
never given.

### Audit findings this plan acts on

- 105 `.nix` files under `modules/`, **32 hidden behind `_`** (30%).
- Of those 32, only **9 genuinely cannot be flake-parts modules**: seven files
  imported as *values* (`import ./style.nix {inherit config;}`), the
  `callPackage` target `_pkgs/ocr-copy.nix`, and the deliberately-unloaded
  `_dormant/ghostty`.
- **~21 are ordinary Home Manager modules**, hidden only because the `_`
  boundary was drawn around whole subtrees rather than around the non-module
  leaves.
- Non-`.nix` assets never needed `_` at all — import-tree collects only `.nix`
  files. Verified empirically. `_discord` and `_opencode` are hidden for no
  reason.
- `modules/_dormant` is referenced by nothing.
- No file inside a `_` directory declares `flake.modules`. Good — that would be
  silently unreachable code.

`_` is import-tree's documented escape hatch *from* auto-discovery, not part of
the Dendritic pattern. Using it is fine. Using it as a grouping mechanism is
what this plan undoes.

---

## Ground rules

1. **Every step ends buildable.** `./scripts/verify.sh build` must report 6 OK
   before committing. Never commit a broken tree to fix in the next one.
2. **`git add -A` before every `nix` command.** Flakes only see tracked files.
3. **Never run `nix flake update`.** Adding an input and running
   `nix flake lock` is fine.
4. **Build only, never switch.** The human switches.
5. **One concern per commit.** These steps move store paths; small commits are
   what make a bisect possible.
6. **No opportunistic changes.** If you spot something wrong, write it down and
   raise it — do not fix it inside an unrelated step.

### `swift5` is the control

`swift5` runs no Hyprland and carries neither `maximal` nor the new `hyprland`
aspect. **Every step here must leave both swift5 targets byte-identical.** If a
swift5 path moves, the step leaked into shared ground — stop and find out why.
This costs nothing and catches the most likely class of mistake.

---

## Verification

There is no baseline worktree any more, so store-path equality is no longer the
test. Paths *will* move: reordering modules changes `buildEnv` order. The
question is whether anything changed **besides** order.

Per step:

```bash
git worktree add ../dotfiles-prev <previous-commit>

./scripts/verify.sh build            # all 6 must be OK

for h in swift5 gpc UM790pro; do
  old=$(nix build --no-link --print-out-paths \
        "../dotfiles-prev#homeConfigurations.\"marcus@$h\".activationPackage")
  new=$(nix build --no-link --print-out-paths \
        ".#homeConfigurations.\"marcus@$h\".activationPackage")

  nix store diff-closures "$old" "$new"          # must be EMPTY
  diff -rq "$old/home-files" "$new/home-files"   # only intended files
done

git worktree remove ../dotfiles-prev
```

**`diff-closures` empty** means no package was added, removed or version-changed:
same software, different order. **`diff -rq` naming only files you meant to
touch** means no generated config drifted. Together these are as strong as the
old byte-identity check for structural work, and unlike it they survive
intentional change.

When a step is *meant* to change generated text, diff the config file itself,
not the store path.

---

## Step 0 — Boundary decision (human answers before Step 1)

Four members of `maximal` are genuinely ambiguous. Decide before touching code;
guessing means redoing Steps 1–3.

| Member | Coupling to Hyprland | Question |
|---|---|---|
| `waybar` | `hyprland/workspaces` and `hyprland/window` modules; systemd target `wayland-session@hyprland.desktop.target` | Hard-coupled. Move to `hyprland`, or keep in `maximal` and accept it breaks under another compositor? |
| `bash.nix` uwsm autostart | `uwsm check may-start` / `uwsm start default` on login | This is session startup, not shell config. Move to `hyprland`? |
| `thunar.nix` | uwsm slice placement for its daemon windows | Only the slice is coupled, not the file manager. Split or leave whole? |
| `packages.nix` | comments mark part of the list "Hyprland-specific / used by the hyprland binds" | Split the tooling out, or leave the list whole? |

Recommendation: move `waybar` and the uwsm autostart into `hyprland`; leave
`thunar` and `packages` in `maximal` and revisit once the aspect exists —
splitting a package list is easy later and hard to review inside a structural
step.

**Flagged, not part of this plan:** `modules/home/xdg.nix` writes `uwsm/env` in
the **core** aspect, so swift5 gets a uwsm config it never uses. Harmless, but
core is carrying maximal's concern. Own commit, separate from this work.

---

## Step 1 — Create the `hyprland` aspect

Move the contents of `modules/maximal/hyprland.nix` into
`modules/hyprland/session.nix`, declaring `flake.modules.homeManager.hyprland`
and `flake.modules.nixos.hyprland` (the latter carries `programs.hyprland` and
`security.pam.services.hyprlock`). Add `"hyprland"` to gpc's and UM790pro's
aspect lists.

Do **not** move anything inside `_hyprland` yet. This step only changes who owns
the tree.

Aspect order in the host list decides merge order, so put `hyprland` where
`maximal` sits today — `["core" "hyprland" "maximal"]` — making the split a
partition rather than a reordering.

- swift5: byte-identical.
- gpc/UM790pro: `diff-closures` empty, `diff -rq` empty or near-empty.

## Step 2 — Surface `_hyprland`

Each plain module becomes its own discovered file under `modules/hyprland/`,
declaring `flake.modules.homeManager.hyprland`:

```
hypridle.nix  hyprlock.nix
hyprland/{animations,binds,core,hyprland,monitors,rules}.nix
hyprpaper/{wallpaper-picker,wallpaper-service}.nix
```

`_hyprland/default.nix` and `_hyprland/hyprland/default.nix` are pure
aggregators and simply disappear.

**`hyprpaper/wallpapers.nix` stays hidden**, as `modules/hyprland/_wallpapers.nix`.
Three files do `import ./wallpapers.nix {inherit pkgs;}` — it is a value, not a
module, and cannot become an aspect.

**Bonus:** once these are flake-parts modules they can capture the flake-parts
`config` in an outer `let` and read `flake.lib.monitors` directly, so the
`_module.args.render` bridge added during Phase 3 becomes unnecessary. Delete it
here.

Watch merge order *within* the aspect: import-tree walks lexicographically, so
each file now sorts against new siblings. `diff-closures` catches any real
consequence.

## Step 3 — Move whatever Step 0 decided

Expect `waybar` to be the interesting one: three files in `_waybar`, no
value-imports, no assets — so it surfaces at the same time it moves.

## Step 4 — Surface the remaining unnecessary `_` trees

`_thunderbird` (2 files), `_discord` (1 file + JSON assets), `_opencode`
(2 files + markdown assets). None contain value-imports.

Assets stay put and keep their relative references — they need co-location, not
hiding. A directory holding only assets can keep any name, since import-tree
ignores non-`.nix` files entirely.

## Step 5 — Leave the rest alone, and write down why

`_walker` (4 value-imported data files), `_yazi` (2), `_pkgs/ocr-copy.nix`
(a derivation), `_dormant/ghostty` (deliberately unloaded). These are correct
uses of the escape hatch.

Add the rule to `CLAUDE.md` so the next pass does not re-litigate it:

> `_` marks files that are **not** flake-parts modules — values consumed by
> `import`, derivations consumed by `callPackage`, and dormant code. It is not a
> grouping mechanism. Grouping is what aspect names are for.

Consider deleting `_dormant/ghostty` outright; git remembers.

---

## Traps

- **Aspect elements are `types.raw`, not `deferredModule`.** `deferredModule`
  rewrites each element's `_file`, which is its module key, which changes
  collection order and so reorders list-valued options. Do not "improve" this.
- **`config` shadowing.** Inside
  `flake.modules.homeManager.foo = [ ({config, ...}: ...) ]`, `config` is the
  Home Manager config. To reach flake-parts, capture it outside:
  `{config, ...}: let top = config; in { ... top.flake.lib ... }`. Getting this
  wrong gives infinite recursion, not a clear error.
- **The generator owns the import lists.** `imports` computed from a module
  *argument* collect in a different order than static ones. `modules/lib/mk-hosts.nix`
  splices aspects at a fixed depth; do not move that.
- **import-tree skips any path containing `/_`** and collects only `.nix` files.
- **Every module file is evaluated for every host.** A syntax error in a
  Hyprland-only file breaks the swift5 build too. Expected, not a regression.
- **Home Manager is standalone.** Outputs are
  `homeConfigurations."marcus@<host>"`, activated separately, on
  `nixpkgs.legacyPackages.${system}` — flake overlays do not reach them.

---

## Out of scope

- Quickshell. Waybar and walker stay.
- Typing the rest of the host record (issue #3 item 2).
- `_class` enforcement on aspect elements (issue #3 item 1).
- Overlays for Home Manager. Affects every home store path; its own project.
- Splitting stylix out of `maximal` into a `theme` aspect. Plausibly the next
  refactor after this one, but not this one.

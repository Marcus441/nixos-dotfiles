# Refactor Plan: close the §11 divergences

`CLAUDE.md` defines the invariants and lists, in §11, the places this repo does not yet
satisfy them. **That list is the backlog. This file is the order.** Its item numbers are
stable identities — a closed item is deleted and the rest keep their numbers — so the
§11.x citations below stay valid as the list shrinks.

Do not restate the invariants here — read them there. This document only says what to do
next, in what sequence, and how to know it worked.

The Dendritic migration and the typed-monitor work are finished; the byte-identity
baseline is retired and `../dotfiles-old` is gone. Earlier plans are in git history:

```bash
git log --oneline --all -- REFACTOR.md
```

## Progress

Update this list in the commit that completes each step. It is the only record of where
the work is — the plan is otherwise stateless, and a fresh session will start at the top.

- [x] **Step 0** — flatten the directory tree (`8b28361`), six targets byte-identical
- [x] **Step 1** — re-test `deferredModule`: it holds, six targets byte-identical
- [x] **Step 2** — `extraSpecialArgs` → `_module.args`, six targets byte-identical
- [ ] Step 3 — theming becomes an axis
- [ ] Step 4 — `hyprland` and `dwl` aspects
- [ ] Step 5 — `gaming` and `nvidia`
- [ ] Step 6 — surface the `_` trees
- [ ] Step 7 — retire the archetype names, create `laptop`
- [ ] Step 8 — darwin groundwork

---

## Target state

When this is done, host files read as archetypes and nothing else:

```nix
swift5   = ["core" "laptop" "dev" "dwl" "palette"];
gpc      = ["core" "gaming" "nvidia" "hyprland" "stylix" "apps"];
UM790pro = ["core" "dev" "hyprland" "stylix" "apps"];
mbp      = ["core" "laptop" "dev" "aerospace" "stylix"];   # planned
```

Every name there is a decision some host makes differently. `core` is what nobody opts out
of. Two entries are genuine open questions, flagged at the steps that create them: whether
`gpc` takes `apps`, and whether `dev` on a gaming rig is really absent or just untested.

`maximal` and `suckless` do not survive. They are host archetypes wearing aspect names,
which is what §11.2 is about.

---

## Ground rules

`CLAUDE.md` §8, §9 and §12 apply in full. The ones that bite hardest here:

- **`swift5` is a control only where a step says so.** It is *not* a blanket stop
  condition — Steps 3, 4, 6, 7 and 8 change swift5 by design. Each step states its own
  expectation, and only these two are byte-identity controls:

  | Step | swift5 | gpc | UM790pro |
  | --- | --- | --- | --- |
  | 0 paths | identical | identical | identical |
  | 1 deferredModule | identical *(measured; "may move" was allowed)* | identical | identical |
  | 2 `_module.args` | identical | identical | identical |
  | 3 theming | **changes** | **changes** | **changes** |
  | 4 sessions | **changes** | **changes** | **changes** |
  | 5 gaming/nvidia | identical | **changes** (nixos) | identical |
  | 6 surface `_` | **changes** | **changes** | **changes** |
  | 7 rename aspects | **changes** | **changes** | **changes** |

  Treat a deviation from that column as the signal, not "swift5 moved".

- **Aspect order in a host list is load-bearing.** It sets module merge order, which
  reaches derivation hashes. When splitting one aspect into two, put the new names where
  the old one sat so the split is a partition, not a reordering.
- **What reaches store paths is the relative order of files contributing to the *same*
  aspect.** `import-tree` walks depth-first, per-directory alphabetical (see `CLAUDE.md`
  §4). But `home.packages` is the concatenation over the aspect list, so interleaving files
  of *different* aspects is invisible — the aspect list already separated them.

  Step 0 measured both sides. Relocating ~70 files was byte-identical, because a total
  flatten preserves within-aspect relative order. Renaming `monitors.nix` →
  `dwl-monitors.nix` moved its package from position 1 to 11, because it changed that
  file's rank among its own aspect's siblings.

  **A partial move is therefore not automatically free.** Step 6 surfaces `_hyprland/*.nix`
  into `modules/`, moving them relative to hyprland-aspect files that are already flat —
  which is why its row says **changes**, and now says it for a reason rather than a guess.

  Step 1 could have invalidated all of this — if `deferredModule` keyed on `_file`,
  directory moves would become hash-moving. It stuck, and the re-measurement says the model
  survives: `modules/monitors.nix` → `modules/monitors/monitors.nix`, a move that changes
  `_file` while preserving walk position, left swift5 byte-identical. So a **position-
  preserving** move is still free.

  That is one data point and it is narrow. It says nothing about moves that *change*
  position, which is exactly what Step 6 does. Measure rather than predict regardless, since
  discovery order is not strictly positional (`CLAUDE.md` §4).
- **Declare before you reference.** The generator rejects an aspect name that resolves in
  no class, so a commit that adds a name to a host list before the declaring file exists
  will not evaluate. Land the file first, or both in one commit — otherwise a bisect
  lands on a broken tree.
- **One concern per commit.** These steps move store paths by design; small commits are
  what make a bisect possible.
- **The human switches and confirms before the next step** for every step marked
  **changes** above. This is not restated per-step; absence is not permission.

### Verification

`./scripts/verify.sh build` must report 6 OK before every commit. Then prove nothing
changed but order:

Run this as one block — every command below depends on `$h`:

```bash
git worktree add ../dotfiles-prev <previous-commit>

for h in swift5 gpc UM790pro; do
  echo "=== $h ==="

  old=$(nix build --no-link --print-out-paths \
        "../dotfiles-prev#homeConfigurations.\"marcus@$h\".activationPackage")
  new=$(nix build --no-link --print-out-paths \
        ".#homeConfigurations.\"marcus@$h\".activationPackage")

  nix store diff-closures "$old" "$new"          # must be EMPTY
  diff -rq "$old/home-files" "$new/home-files"   # only intended files

  # diff-closures alone is NOT sufficient: a module that vanishes while setting
  # only config values adds no package, so the closure is unchanged.
  oldt=$(nix build --no-link --print-out-paths \
         "../dotfiles-prev#nixosConfigurations.$h.config.system.build.toplevel")
  newt=$(nix build --no-link --print-out-paths \
         ".#nixosConfigurations.$h.config.system.build.toplevel")

  diff -rq "$oldt/etc" "$newt/etc" 2>&1 | grep -v "^diff:.*No such file"
done

git worktree remove ../dotfiles-prev
```

Empty `diff-closures` means no package was added, removed or version-changed. `diff -rq`
naming only files you meant to touch means no generated config drifted. The `grep -v`
drops dangling-symlink noise, which is expected and not a real difference.

---

## Step 0 — Flatten the directory tree (§11.3)

**First, because a total flatten is free and may not stay that way.** *(Done — `8b28361`.)*

`modules/home/` and `modules/nixos/` were the first row of `CLAUDE.md` §10's anti-pattern
table — paths encoding class. `modules/maximal/` and `modules/suckless/` encoded a host
archetype. Under Invariant 4 none of them meant anything, but an agent reading the tree as
a schema would have reproduced them.

The original rationale here was that *renames* are free. **That was wrong**, and Step 0 is
where it was caught: it rested on renaming `modules/jq.nix`, a file that sets only
`programs.jq.enable` and so contributes nothing positional to `home.packages`. A null
experiment.

What is true is narrower and was enough: a *total* flatten preserves within-aspect relative
order, so it costs nothing, while Step 1 may make even directory moves hash-moving. The
reorganisation was worth buying at zero rather than at an unknown price — but see the
ground rules for what that does and does not license.

Do **not** change any aspect membership: this step is a pure rename, so that any path
movement is unambiguous evidence of something you did not expect.

### Target layout

```
modules/
  aspects.nix                      # was lib/aspects.nix
  hosts/{generator,swift5,gpc,UM790pro}.nix   # generator was lib/mk-hosts.nix
  display/{monitor-option,render}.nix
  font/ mako/ bash/ packages/      # concerns currently split across buckets
  _hyprland/ _waybar/ _walker/ _yazi/ _thunderbird/ _discord/ _opencode/
  _pkgs/ _dormant/
  <concern>.nix                    # ~50 single-file concerns, flat
```

**`_`-prefixed trees keep their underscores.** Dropping them would surface ~21 modules and
change all six targets inside a step whose entire verification is byte-identity. Surfacing
is Step 6.

**`lib/` disappears.** `CLAUDE.md` §4 blesses `lib/mk-hosts.nix` while §10 forbids `lib/`
directories; moving the two files resolves the contradiction without amending either. The
generator belongs with the host schema it enforces, and `generator.nix` is obviously not a
hostname, so §5's "add `modules/hosts/<hostname>.nix`" recipe stays unambiguous.

### The four collision directories, and what becomes of them

A flat rename collides on four basenames — which is `§11.4` surfacing as a filename clash,
not an obstacle. Each gets a directory here, but they do **not** share a fate, and the
difference matters:

| Directory | Fate |
| --- | --- |
| `font/` | **collapses** to `font.nix` in Step 3 — one concern, three theming audiences |
| `mako/` | **collapses** to `mako.nix` in Step 3 — same |
| `bash/` | **collapses** in Step 3, minus its `profileExtra`, which is the uwsm session autostart and leaves for `hyprland` in Step 4 |
| `packages/` | **dissolves.** Not a concern — a junk drawer. `packages` names no decision and no capability, so §3 would reject it as an aspect name and it is no better as a file name. Its contents redistribute to real concerns in Steps 6–7. |

`packages/` exists only to keep Step 0 mechanical. Do not let it survive because it
outlived a step that was about exactly this.

### Why flat

Not because the pattern demands it — Invariant 4 says paths carry no *meaning*, not that
they must be flat, and grouping for navigation is explicitly fine. Fifty files in one
directory is a navigation cost being chosen, not a tax.

The reason is timing: **the right taxonomy is not knowable until `maximal` dissolves in
Step 7.** Grouping now means grouping with the archetype structure still in your head, and
you would be encoding the thing this refactor exists to remove. Defer it.

Regrouping later was expected to cost one hash-moving commit if `deferredModule` stuck. It
stuck and that cost did not appear: a position-preserving grouping move measured free (see
the ground rules). A regroup that *reorders* files within an aspect is still a hash-moving
commit — which the harness verifies fine, but accept that knowingly rather than discover it.

**The test for any grouping, then or now:** a directory is safe when its name would be a
*bad aspect name* and the files inside span *more than one aspect*. `font/` passes — bad
aspect name, spans core/stylix/palette. A `system/` directory for the sixteen `nixos.core`
files fails both: every file is nixos-core, so the path predicts class and membership
exactly, which is `modules/nixos/` under another name.

**After this step, every path named in Steps 1–8 is obsolete** — including the two named
in Steps 1 and 2. Those steps describe files by concern; resolve them by content.

- Verify: all six targets byte-identical. Also a free rehearsal of the harness before
  anything semantic moves.

## Step 1 — Re-test `deferredModule`

**Second, because it improves the diagnostics for every step after it.** *(Done — it holds.
`modules/aspects.nix` now uses `deferredModule`; all six targets came out byte-identical,
and `modules/stylix.nix`, the repo's only multi-element declaration, kept both elements.
The measured before/after conflict message is in `CLAUDE.md` §8.)*

This placement is a deliberate trade, not an obvious ordering. Step 1 is the only step
whose outcome is unknown, and it sits *before* Step 2 proves the harness works — so if it
goes badly you spend the run's most confusing debugging first. The alternative, 0 → 2 → 1,
lets a pure no-op validate `verify.sh` before anything uncertain. It was rejected because
Step 2 rewrites ten files, and `deferredModule`'s file-naming in error messages is exactly
what makes that legible when it goes wrong. If Step 1 stalls, do Step 2 first and come
back — nothing depends on the order.

Aspect elements are `types.raw`, so option conflicts report `<unknown-file>` twice instead
of naming files. Across 105 files that is a real tax, and the next seven steps are exactly
the kind of work that provokes conflicts. `deferredModule` restores `_file`.

`raw` was chosen under the Phase 2 byte-identity constraint, which no longer exists. So
this is now a measurement, not a rule.

Change the element type in the file declaring the `flake.modules` option (Step 0 moved it
to `modules/aspects.nix`) and look for **two different
failures**, not one:

1. **Store paths move.** Expected and acceptable.
2. **Modules silently disappear.** This is the real risk. One *hypothesis* is that
   `setDefaultModuleLocation` stamps every element of a list with the same `_file`, which
   becomes the module key, so a multi-element aspect list declared in one file could
   collide and lose elements. Anonymous modules normally get index-disambiguated keys, so
   this may not be the mechanism — treat it as a thing to look for, not an explanation.

**Counting `builtins.length config.flake.modules.homeManager.<aspect>` does not detect
this.** That list is the same length either way; any dropping happens later, inside the
guest evaluation, when Home Manager collects and deduplicates. The detection is the full
verification block above — `diff-closures`, `diff -rq` on `home-files`, **and** the `/etc`
diff on all three NixOS targets. Run all three parts.

Only multi-element aspect lists declared in a single file are at risk. Enumerate them
first so you know where to look:

```bash
grep -rn "flake\.modules\.[a-zA-Z]*\.[a-zA-Z0-9_-]* = \[" --include=*.nix modules/
```

If it holds, keep it and update `CLAUDE.md` §8. If elements vanish, revert and record in
§8 what actually happened — which is more than is known today either way.

## Step 2 — `extraSpecialArgs` → `_module.args` (§11.1)

*(Done — §11.1 closed. Six targets byte-identical, so the harness is sound.)*

Closes Invariant 5. ~10 files take `monitors`, `sensitivity`, `hostname`, `user` or
`homeStateVersion` as module arguments.

The generator injects them instead, as an ordinary module in the host's list:

```nix
modules = [ {_module.args = {inherit monitors hostname user; /* ... */ };} ] ++ aspects;
```

Consumers do not change — they still receive the same argument names. Only the channel
changes.

Two things to watch:

- A module contributing only `_module.args` adds nothing to any list-valued option, so it
  should not reorder anything. Confirmed, not assumed: the home injection was added as a
  **new first element** of the modules list and all six targets stayed byte-identical.
- **Nothing may use these to compute `imports`.** That is infinite recursion, not an error
  (`CLAUDE.md` §7). Grep for `imports` in the ten consumers before starting. This caught a
  real one: `modules/home-manager.nix` computed `imports` from the `inputs` module arg.
  `inputs` was never in §11.1's list, but Invariant 5 forbids the channel it arrived on, so
  it and the two other `inputs` consumers moved to closure first, as a separate commit.

- Verify: all six targets byte-identical.

**This is the harness test.** Step 2 changes only the channel a value arrives through, so
its output must be identical. If anything drifts here, the fault is in `verify.sh`, the
generator, or your understanding of the module system — not in the change. Diagnose it
before going near Step 3, where drift is expected and would hide the same bug.

## Step 3 — Theming becomes an axis (§11.3, §11.4)

**The step that demonstrates the pattern, and it moves no files.**

Today `font` is split across three files and `mako` across two, because the aspect can say
*which host archetype* but not *who does the theming*. Introduce `stylix` and `palette` as
aspects; hosts take exactly one.

The stylix file declares `flake.modules.homeManager.stylix`; the former suckless theming
files — font, gtk, cursor, qt, mako — declare `palette`. Step 0 already put them at
concern-named paths, so this step changes membership only.

Then collapse the duplicates into the one-file form from `CLAUDE.md` §2:

- `font` — one file declaring `core` (the option), `stylix`, and `palette`.
- `mako` — one file declaring `stylix` and `palette`.
- Rename the option namespace `suckless.font` → `desktop.font`. An option in `core` named
  after an aspect is the clearest single symptom of §11.2.

`suckless.font.size = 20` on the maximal hosts is not theming — it is a HiDPI fact about
those two machines. Push it to the host record and deliver it via Step 2's `_module.args`.

- Verify: 6 OK. All three hosts change. `diff-closures` must still be empty — the packages
  are the same, only which aspect contributes them changes.

## Step 4 — `hyprland` and `dwl` aspects (§11.2)

Split the session out of `maximal` and `suckless`. Step 0 already moved these files to
concern-named paths, so **this step changes membership only** — do not rename anything, or
the interesting diff disappears under moves.

The Hyprland session file declares `flake.modules.nixos.hyprland` and
`flake.modules.homeManager.hyprland`; the dwl half of the dwl file declares `dwl`.

Place the new names where the old ones sat — `["core" "hyprland" "maximal"]` — so this is a
partition.

Anything genuinely shared between the two sessions (locking, notifications, portals,
clipboard) becomes its own aspect rather than being duplicated. Anything portable in
*intent* (gaps, mod key, keybinding philosophy) becomes an option namespace consumed by
both, per `CLAUDE.md` §3 — **not** one aspect that branches internally.

Decide during this step, from `CLAUDE.md` §4's coupling table:

- **waybar** is hard-coupled to Hyprland (`hyprland/workspaces`, `hyprland/window`,
  `wayland-session@hyprland.desktop.target`). It moves.
- **the uwsm autostart** — the `uwsm check may-start` / `uwsm start default` block in the
  maximal bash file — is session startup wearing shell clothing. It moves.
- **thunar** is coupled only by a uwsm slice; **packages.nix** is partly Hyprland tooling.
  Leave both, revisit in Step 6.

**`suckless` ends here.** Its seven files are fully consumed by Steps 3 and 4 — font, gtk,
cursor, qt and mako to `palette`; dwl and the wlr-randr monitor script to `dwl`. Delete the
aspect name and remove it from swift5's list in this step. If anything is left over, it is
a member you have not classified — do not leave the name alive to hold it.

## Step 5 — `gaming` and `nvidia` (§11.6)

The clearest latent aspects in the repo: nvidia drivers, steam, gamescope and gamemode are
inline in gpc's host `nixos` block. That is reusable configuration written as host-local —
a second nvidia machine means copy-paste.

Lift them into `modules/gaming.nix` and `modules/nvidia.nix`, add both to gpc's aspect
list. `nixpkgs.config.allowUnfree` moves to `core`; it is not a gaming fact.

Small, self-contained, and the first step that makes a host file read as an archetype.

- Verify: swift5 and UM790pro byte-identical; gpc's nixos target moves, home does not.

## Step 6 — Surface the `_` trees (§11.5)

~21 ordinary modules are hidden inside `_hyprland`, `_waybar`, `_thunderbird`, `_discord`,
`_opencode` for no reason beyond the boundary having been drawn around whole subtrees.
Each becomes a discovered file declaring its own aspect membership.

Stays hidden, correctly: the seven value-imported data files (`_walker`, `_yazi`,
`hyprpaper/wallpapers.nix`), `_pkgs/ocr-copy.nix`, and `_dormant/ghostty` — consider
deleting that last one outright.

Once `_hyprland`'s files are flake-parts modules they can read `flake.lib.monitors`
directly, so the `_module.args.render` bridge disappears.

Assets need no underscore at all — `import-tree` collects only `.nix`.

**Watch the file body, not the aspect contents.** A surfaced file is evaluated for every
host at the flake-parts level, even though the modules *inside* its aspect list stay lazy.
Anything Hyprland-specific pulled into a `let` at the top of the file — a package
reference, an `inputs.hyprland` attribute — now evaluates on swift5 too. Keep such
references inside the aspect list where laziness protects them.

## Step 7 — Retire the archetype names, create `laptop` (§11.2)

Two halves, both finishing the archetype story.

**`maximal` → `apps`.** Whatever survives Steps 3, 4 and 6 is the heavy app set. Decide
then whether `gpc` takes it — a gaming rig may not want thunderbird.

**Create `laptop`.** The target state names it on swift5 and mbp, and nothing has created
it yet. It gathers what is currently scattered:

- `networking.networkmanager.wifi.powersave` — set `true` on swift5 and `false` on
  UM790pro from their host files, so it is a genuine per-host difference, not a constant;
- `power-profiles-daemon` and `upower`, currently in `core` where the gaming rig and the
  dev box also get them;
- `brightnessctl`, currently in core packages, used by hypridle's dim-on-idle.

Be careful splitting `power.nix`: a desktop losing `upower` may break status tooling that
assumes it. If in doubt leave it in `core` and take only the unambiguous members — an
aspect that is too small is recoverable, a broken suspend path on the primary machine is
not.

At this point `CLAUDE.md` §11 items 1–6 are closed and every host file reads as an
archetype.

## Step 8 — Darwin groundwork (§11.7)

Only once the above is done, and only when there is a Mac to test on.

- Add `aarch64-darwin` to `systems`. `perSystem` evaluates for *every* entry, unlike
  aspect contents (`CLAUDE.md` §6), so every Linux-only output must be excluded —
  **by attribute, not by value**:

  ```nix
  # right: the attribute does not exist on darwin, so the RHS is never evaluated
  packages = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
    foo = pkgs.someLinuxOnlyThing;
  };

  # wrong: mkIf gates the value, but pkgs.someLinuxOnlyThing still evaluates
  packages.foo = lib.mkIf pkgs.stdenv.hostPlatform.isLinux pkgs.someLinuxOnlyThing;
  ```

  Same eval-time versus config-time distinction as `CLAUDE.md` §8; this is the one place
  it bites hardest.
- Add `mkDarwin` to the generator alongside `makeSystem` and `mkHome`.
- Standalone Home Manager is the asset here: the same home aspects activate on macOS with
  no NixOS underneath.
- Name the intent aspects — `launcher`, `screenshot`, `clipboard`, `lock`,
  `notifications` — with per-platform implementations.

---

## Done means

`CLAUDE.md` §11 lists only item 7, and:

- no `specialArgs` or `extraSpecialArgs` anywhere;
- at least one file contributing to two aspects, and no concern split across files
  because of a bucket;
- no aspect named for a magnitude or a host archetype — `maximal` and `suckless` are both
  gone, not merely unused;
- **no directory named for a class or an archetype** — no `modules/home/`,
  `modules/nixos/`, `modules/maximal/`, `modules/suckless/`, and no `lib/`.
  `CLAUDE.md` §10 row one;
- **no `packages` concern** — neither `modules/packages.nix` nor `modules/packages/`.
  A package list is not a decision; its members belong with the concerns that want them;
- `/_` only on non-modules;
- every host file readable as "what this machine is".

Update §11 in the same commit that closes each item. It is a ratchet, not a ledger.

---

## Out of scope

- Quickshell. Waybar and walker stay.
- Typing the rest of the host record (issue #3 item 2) and `_class` enforcement on aspect
  elements (issue #3 item 1).
- Overlays reaching Home Manager. Changing `pkgs` for home configs moves every home store
  path; its own project, with its own switch cycle.
- The xdg concern writes `uwsm/env` into `core`, so swift5 carries a uwsm config it never
  uses. Real, small, unrelated — own commit.

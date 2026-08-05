# Refactor Plan: close the §11 divergences

`CLAUDE.md` defines the invariants and lists, in §11, the seven places this repo does not
yet satisfy them. **That list is the backlog. This file is the order.**

Do not restate the invariants here — read them there. This document only says what to do
next, in what sequence, and how to know it worked.

The Dendritic migration and the typed-monitor work are finished; the byte-identity
baseline is retired and `../dotfiles-old` is gone. Earlier plans are in git history:

```bash
git log --oneline --all -- REFACTOR.md
```

---

## Target state

When this is done, host files read as archetypes and nothing else:

```nix
swift5   = ["core" "laptop" "dev" "dwl"      "palette"];
gpc      = ["core" "gaming" "nvidia" "hyprland" "stylix" "apps"];
UM790pro = ["core" "dev"              "hyprland" "stylix" "apps"];
mbp      = ["core" "laptop" "dev"     "aerospace" "stylix"];   # planned
```

Every name there is a decision some host makes differently. `core` is what nobody opts out
of. Two entries are genuine open questions, flagged at the steps that create them: whether
`gpc` takes `apps`, and whether `dev` on a gaming rig is really absent or just untested.

`maximal` and `suckless` do not survive. They are host archetypes wearing aspect names,
which is what §11.2 is about.

---

## Ground rules

`CLAUDE.md` §8, §9 and §12 apply in full. The ones that bite hardest here:

- **`swift5` is the control.** It takes neither `hyprland` nor `stylix`. Until Step 5
  touches it directly, **every step must leave both swift5 targets byte-identical.** A
  swift5 path that moves means the change leaked into shared ground — stop and find out
  why before continuing.
- **Aspect order in a host list is load-bearing.** It sets module merge order, which sets
  `buildEnv` order, which reaches derivation hashes. When splitting one aspect into two,
  put the new names where the old one sat so the split is a partition, not a reordering.
- **One concern per commit.** These steps move store paths by design; small commits are
  what make a bisect possible.

### Verification

`./scripts/verify.sh build` must report 6 OK before every commit. Then prove nothing
changed but order:

```bash
git worktree add ../dotfiles-prev <previous-commit>

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

Empty `diff-closures` means no package was added, removed or version-changed. `diff -rq`
naming only files you meant to touch means no generated config drifted.

**The human switches, and confirms, before the next step** whenever a step changes
generated config rather than only its order.

---

## Step 1 — Re-test `deferredModule` (§11 groundwork)

**First, because it improves the diagnostics for every step after it.**

Aspect elements are `types.raw`, so option conflicts report `<unknown-file>` twice instead
of naming files. Across 105 files that is a real tax, and the next seven steps are exactly
the kind of work that provokes conflicts. `deferredModule` restores `_file`.

`raw` was chosen under the Phase 2 byte-identity constraint, which no longer exists. So
this is now a measurement, not a rule.

Change the element type in `modules/lib/aspects.nix` and look for **two different
failures**, not one:

1. **Store paths move.** Expected and acceptable — check `diff-closures` is empty.
2. **Modules silently disappear.** This is the real risk. `setDefaultModuleLocation` stamps
   every element of one list with the same `_file`, and `_file` becomes the module key, so
   a multi-element aspect list declared in a single file may collide and lose elements.
   A non-empty `diff-closures` showing *removed* packages is the signature.

If it holds, keep it and update `CLAUDE.md` §8. If elements vanish, revert, and record in
§8 that `deferredModule` is unusable *for this reason* — which is more than is known today.

- Verify: 6 OK, `diff-closures` empty on all three hosts.

## Step 2 — `extraSpecialArgs` → `_module.args` (§11.1)

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
  should not reorder anything. Confirm rather than assume.
- **Nothing may use these to compute `imports`.** That is infinite recursion, not an error
  (`CLAUDE.md` §7). Grep for `imports` in the ten consumers before starting.

- Verify: all three hosts byte-identical. This step should be a pure no-op in output.

## Step 3 — Theming becomes an axis (§11.3, §11.4)

**The step that demonstrates the pattern, and it moves no files.**

Today `font` is split across three files and `mako` across two, because the aspect can say
*which host archetype* but not *who does the theming*. Introduce `stylix` and `palette` as
aspects; hosts take exactly one.

`modules/maximal/stylix.nix` declares `flake.modules.homeManager.stylix`;
`modules/suckless/{font,gtk,cursor,qt,mako}.nix` declare `palette`. **Their paths stay
wrong for now and that is fine** — Invariant 4 means paths carry no meaning, and fixing
them here would bury the interesting diff under renames.

Then collapse the duplicates into the one-file form from `CLAUDE.md` §2:

- `font` — one file declaring `core` (the option), `stylix`, and `palette`.
- `mako` — one file declaring `stylix` and `palette`.
- Rename the option namespace `suckless.font` → `desktop.font`. An option in `core` named
  after an aspect is the clearest single symptom of §11.2.

`suckless.font.size = 20` on the maximal hosts is not theming — it is a HiDPI fact about
those two machines. Push it to the host record and deliver it via Step 2's `_module.args`.

This step changes generated config. **Human switches and confirms before Step 4.**

- Verify: 6 OK. swift5 and the maximal hosts all move; `diff-closures` must still be empty.

## Step 4 — `hyprland` and `dwl` aspects (§11.2)

Split the session out of `maximal` and `suckless`. `modules/maximal/hyprland.nix` becomes
`modules/hyprland.nix` declaring both classes; the dwl half of `modules/suckless/dwl.nix`
becomes `modules/dwl.nix`.

Place the new names where the old ones sat — `["core" "hyprland" "maximal"]` — so this is a
partition.

Anything genuinely shared between the two sessions (locking, notifications, portals,
clipboard) becomes its own aspect rather than being duplicated. Anything portable in
*intent* (gaps, mod key, keybinding philosophy) becomes an option namespace consumed by
both, per `CLAUDE.md` §3 — **not** one aspect that branches internally.

Decide during this step, from `CLAUDE.md` §4's coupling table:

- **waybar** is hard-coupled to Hyprland (`hyprland/workspaces`, `hyprland/window`,
  `wayland-session@hyprland.desktop.target`). It moves.
- **the uwsm autostart** in `modules/maximal/bash.nix` is session startup wearing shell
  clothing. It moves.
- **thunar** is coupled only by a uwsm slice; **packages.nix** is partly Hyprland tooling.
  Leave both, revisit in Step 6.

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

## Step 7 — Retire `maximal` (§11.2)

Whatever is left after Steps 3, 4 and 6 is the heavy app set. Name it `apps`, and decide
then whether `gpc` takes it — a gaming rig may not want thunderbird.

At this point `CLAUDE.md` §11 items 1–6 are closed and host files are archetypes.

## Step 8 — Darwin groundwork (§11.7)

Only once the above is done, and only when there is a Mac to test on.

- Add `aarch64-darwin` to `systems`, and gate every Linux-only `perSystem` output on
  `pkgs.stdenv.hostPlatform` — `perSystem` evaluates for *every* entry, unlike aspect
  contents (`CLAUDE.md` §6).
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
- no aspect named for a magnitude or a host archetype;
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
- `modules/home/xdg.nix` writing `uwsm/env` in `core`, so swift5 carries a uwsm config it
  never uses. Real, small, unrelated — own commit.

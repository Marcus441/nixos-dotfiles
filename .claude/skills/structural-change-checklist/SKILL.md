---
description: >-
  Use before committing a structural change — moving, renaming, or regrouping
  files; adding, splitting, or renaming aspects; changing a host's aspect list;
  editing the generator or aspects.nix. Runs the invariant self-check,
  anti-pattern scan, and verification steps.
---

# Structural change checklist

**Structural** = moving/renaming/regrouping files, adding/splitting/renaming
aspects, changing a host's aspect list, editing `modules/hosts/generator.nix`
or `modules/aspects.nix`.

## 1. Invariant self-check

If the change would violate one, **stop and say so.** Do not silently bend a
rule — the invariants are the whole value of this structure, and a single
exception metastasises.

1. Every `.nix` file under `modules/` is a flake-parts module.
2. `flake.nix` is a manifest — no configuration logic.
3. One file = one concern, across every class and aspect it touches.
4. File paths name the feature but carry no system-meaning.
5. No `specialArgs` / `extraSpecialArgs`.
6. No manual import lists except the host wiring.
7. Aspects are host-agnostic and platform-agnostic.

## 2. Anti-pattern scan

| Anti-pattern | Why |
| --- | --- |
| `nixos/`, `home/`, `darwin/` directories | Paths encode class (Inv. 4) |
| `pkgs/`, `overlays/`, `profiles/` directories | Breaks feature closure |
| `lib/` directory of helpers | Not a flake-parts module (Inv. 1) |
| `imports = [ ./foo.nix ]` inside `modules/` | `import-tree` already loaded it (Inv. 6) |
| `specialArgs = { inherit self inputs; }` | Closure or `_module.args` (Inv. 5) |
| `_` to group related files | `/_` is for non-modules only |
| Aspect named `maximal` / `minimal` | Magnitude, not a decision |
| `mkEnableOption` per aspect | Hosts compose by taking aspects, not by enabling |
| One aspect that branches between dwl and Hyprland | Option namespace + variant aspects |
| Aspect reading `config.networking.hostName` | Aspects are host-agnostic (Inv. 7) |
| Editing three files to add one feature | Wrongly decomposed (Inv. 3) — but one file installing into several aspects is not this |

Directory test: if every file inside declares the same *declining* aspect, the
directory is redundant and the files should be flat. `core` does not count
toward "several aspects" — every host takes it.

## 3. Ordering check

Aspect order in a host's list reaches derivation hashes. When splitting an
aspect, put the new names where the old one sat. Only the relative order of
files contributing to the *same* aspect matters.

**Treat the model as a working model, not a mechanism** — measurements have
produced results it does not predict. Measure; do not predict.

## 4. Verify

```bash
./scripts/verify.sh build        # all six targets — the real check
nix flake check                  # cheap eval sweep
```

`nixos-rebuild build` covers only three of six targets. Use `verify.sh`.

For a structural change, prove nothing changed but order:

```bash
./scripts/verify.sh <ref>        # compares against any git ref; no arg = HEAD~1
```

The full manual diff-closures recipe is in
`.claude/rules/structural-verification.md`. `swift5` takes neither Hyprland nor
`apps` — a useful control for work on those.

**Do not claim a config builds without having built it. Never switch** — build
only; the human switches. A hook blocks `switch` invocations.

## 5. Debugging

**Bisect eval errors** by temporarily renaming a file to `_name.nix` —
`import-tree` skips it. Halve the tree until the build recovers. Undo before
committing.

**Inspect merged aspects:** `nix repl` → `:lf .` →
`config.flake.modules.homeManager.hyprland`.

## 6. Commit

- Small, single-concern commits. Rationale in the commit message, not in
  comments. Terse comments — explain *why*, never *what*.
- No unrequested changes: no package bumps, no deprecation fixes, no
  reformatting files the task doesn't touch.
- If a file gained or lost an aspect membership, run
  `scripts/recount-aspects.sh` and update the "26 of 109" figure in
  `.claude/rules/nix-file-conventions.md`.
- Finished plans go to git history. Cite a commit hash, never a plan filename.
- If a task touched a file listed under *Known divergences* in CLAUDE.md,
  migrate it in the same change or state why not.

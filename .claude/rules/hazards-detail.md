---
paths: "modules/**/*.nix"
---

# Evaluation hazards

- **Aspect elements are `types.deferredModule`.** Switching from `types.raw`
  left all six targets byte-identical on the flattened tree. The change buys
  provenance across all files `import-tree` loads. Re-run the full
  diff-closures check (`structural-verification.md`) if you change the element
  type again.
- **`config` shadowing** inside `flake.modules.*` — the `config` in scope there
  is the *guest* config, not flake-parts'. See `sharing-values.md`.
- **Every *file* is evaluated once** — a syntax error anywhere breaks every
  host. But an **aspect's contents are only evaluated by hosts that take it.**
- **Eval-time vs config-time.** `lib.mkIf pkgs.stdenv.isLinux { … pkgs.grim … }`
  still evaluates `pkgs.grim`. Guard the reference, not just the config —
  exclude by attribute (`lib.optionalAttrs`), not by value (`lib.mkIf`).
- **An interpolation at column 0 reindents a whole generated file.** `''`
  strips the least indentation; a line beginning `${...}` has none.
- **`git add -A` before every `nix` command.** Flakes see only tracked files.
  A PreToolUse hook does this automatically; it is still the reason a build can
  fail to see a file you just wrote.
- **Build on `UM790pro`.** Building Hyprland closures on `swift5` drags the
  whole chain onto the laptop.

## Things that fail silently rather than loudly

Each of these was measured, not reasoned about. Rationale in
`docs/decisions/`.

- **`flake.modules` is an open attrset.** `flake.modules.homemanager.core`
  type-checks, is read by nobody, and drops its modules in silence — a host
  built fine with the option it set simply absent. The explicit `classes` list
  in `hosts/generator.nix` is what catches it.
- **An option declared outside its own `mkIf` still resolves.** `yazi.nix`'s
  `finalPackage` sits outside `mkIf cfg.enable`, so a host taking `yazi`
  without `apps` would get an unconfigured `pkgs.yazi` rather than an error.
  `aspectRequires` turns that into a rejection naming the aspect.
- **A second `ExecStart=` on a non-oneshot systemd service refuses to load.**
  NixOS merges `systemd.user.services.<name>` as a drop-in *over* the packaged
  unit, so an override that adds install wiring must not restate `ExecStart`
  (`filemanager/thunar.nix`).
- **`throwIf` order is fold order.** Checks built by folding a list wrap the
  accumulator, so the **last** entry is outermost and fires **first**. A bogus
  aspect name must be reported before the requirements that could not resolve
  because of it (`hosts/generator.nix`).
- **A strict argument pattern is a wiring check.** `makeSystem` matches
  `monitors` and `input` without using them, so a newly declared host option
  must be wired there rather than silently ignored.
- **Reading a merged option back can win the wrong value.** Bind the value
  directly where a `mkForce` elsewhere would otherwise redirect it — see
  `yazi.nix` and `fileManager.command`.

## Ordering is the one thing that reaches a derivation hash

- **Import order** is a depth-first walk, per-directory alphabetical
  (`builtins.attrNames` returns sorted names; directories recurse inline).
- **Aspect order in a host's list is load-bearing.** It determines merge order,
  which determines `buildEnv` order, which reaches derivation hashes. When
  splitting an aspect, put the new names where the old one sat.
- **Only relative order of files contributing to the same aspect matters.**
  Interleaving files of different aspects is invisible — the aspect list
  already separated them.

**Treat it as a working model, not a mechanism.** Measurements have produced
results the model does not predict (e.g. `windowTags` rendered in reverse of
aspect list order). A position-preserving move is free even though it changes
`_file`. **Measure with the diff-closures recipe; do not predict.**

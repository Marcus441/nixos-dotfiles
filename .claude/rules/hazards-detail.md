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

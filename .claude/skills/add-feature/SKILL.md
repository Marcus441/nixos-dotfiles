---
description: >-
  Use when adding a new feature or aspect to the Nix configuration, or when
  extending an existing aspect. Covers naming the aspect, creating the module
  file, declaring membership across classes, intent-vs-implementation splits,
  adding the aspect to hosts, and verifying. Triggers: add a feature, new
  aspect, new module, extend an aspect, enable a program, install a package for
  one host, aspect naming, intent vs implementation, option namespace.
---

# Adding or extending a feature

Naming rules are `AGENTS.md` §3, class placement §6, the merge and the
provider/consumer shape `.claude/rules/modules.md`. This is the procedure.

## Add a feature

1. **Name the aspect** after the decision or capability (§3). If every host
   would take it, it is `core`, not a new aspect.
2. **Create `modules/<concern>.nix`.** Declare membership for every class and
   aspect it touches — one file, all of them. `modules/filemanager/thunar.nix`
   is the file to copy.
3. **Add the aspect name to the relevant hosts** (`modules/hosts/<hostname>.nix`).
   Position in the list is load-bearing — `.claude/rules/host-wiring.md`.
4. **Verify:** `./scripts/verify.sh build`, then `./scripts/verify.sh HEAD~1`
   against a predicted six-target signature.

## Extend a feature

Add a **new file** targeting the same `flake.modules.<class>.<aspect>`. Do not
add an enable flag — split into two files and let hosts differ by aspect.

## When two implementations compete

Do **not** build one aspect that branches internally. The portable part is an
option namespace in `core`; the implementations are separate aspects, and the
setter lives in the provider's file. Worked shapes and the existing namespaces:
`docs/conventions/intents.md`.

## Before you finish

- Does the feature need a `docs/` entry? Only if changing a value breaks
  something non-obviously — then add the anchor *and* the `# load-bearing:`
  pointer together, and keep it inside the budgets in `AGENTS.md` §10.
- `./scripts/docs-check.sh` must pass. It will reject a pointer that does not
  resolve and an anchor nothing points at.
- Check `AGENTS.md` §8 before treating a neighbouring file as an example.
- Small, single-concern commit; rationale in the message, not in comments.

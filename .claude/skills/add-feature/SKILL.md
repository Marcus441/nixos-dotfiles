---
description: >-
  Use when adding a new feature or aspect to the Nix configuration, or when
  extending an existing aspect. Covers naming the aspect, creating the module
  file, declaring membership across classes, intent-vs-implementation splits,
  adding the aspect to hosts, and verifying.
---

# Adding or extending a feature

## Add a feature

1. **Name the aspect** after the decision or capability (see *Naming*, below).
2. **Create `modules/<concern>.nix`.** Declare membership for every class and
   every aspect it touches — one file, all of them. `modules/filemanager/thunar.nix`
   is the file to copy: one concern, two aspects, both classes.
3. **Add the aspect name to the relevant hosts** (`modules/hosts/<hostname>.nix`).
   Position in the list is load-bearing — see `.claude/rules/host-wiring.md`.
4. **Verify:** `./scripts/verify.sh build` (all six targets).

## Extend a feature

Add a **new file** targeting the same `flake.modules.<class>.<aspect>`. Do not
add an enable flag — split into two files and let hosts differ by aspect.
`mkEnableOption` per aspect is an anti-pattern: hosts compose by *taking*
aspects, not by enabling them.

## Naming

An aspect is a **decision or a capability**, never a magnitude and never a host
class.

- Good: `hyprland`, `dwl`, `gaming`, `nvidia`, `laptop`, `dev`.
- Bad: `maximal`, `minimal`, `heavy`, `extras` — magnitude names rot.
- Bad: `desktop-machine`, `workstation` — that is a host archetype, not a
  concern.

**An aspect earns its existence when some host says no.** If all hosts always
take it, it is `core`. A bad name is cheap to fix — renaming an aspect only
moves store paths if it changes a host's aspect list position.

## Intent vs implementation

Two compositors share intent but no code. Do **not** build one `tiling-wm`
aspect that branches internally. Instead: the portable part is an **option
namespace** in `core`; the implementations are **separate aspects**.

- `modules/launcher.nix` — declares `launcher.argv` in `core` (the intent).
- `modules/walker.nix` — sets it from `hyprland`.
- `modules/wmenu.nix` — sets it from `dwl`.

The setter sits in the provider's file, not in `launcher.nix` — otherwise
`launcher.nix` would be edited every time a launcher changed (Inv. 3 inverted).

**A shared namespace is sometimes empty.** `clipboard`, `lock`, and
`screenshot` share intent across sessions but were never abstracted into a
common namespace — the shared config is declared per-session inside the one
file that owns the concern. Zero shared aspects is a valid outcome.

Related patterns: `windowTags` (many setters, one reader) —
`.claude/rules/window-tags.md`.

## Where to put each line

Default to `homeManager`; justify the exception.

| Goes in `homeManager` | Goes in `nixos` / `darwin` |
| --- | --- |
| shell, prompt, editor, git, terminal | services, daemons, systemd/launchd units |
| user packages, dotfiles, keybindings | users, boot, filesystems, networking |
| theming, fonts config, cursor | compositor/session registration, PAM |

## A tool invoked by bare name

It must be installed by **every** aspect that invokes it. `brightnessctl.nix`
declares both `hyprland` and `laptop`, installing the same package twice — that
is correct, not duplication. Where the consumer can hold a store path instead
(`dwl.nix` interpolates it into C code), prefer that.

## Before you finish

- Check CLAUDE.md's *Known divergences* before treating a neighbouring file as
  an example.
- If the file gained or lost an aspect membership, run
  `scripts/recount-aspects.sh` and update the "26 of 109" figure in
  `.claude/rules/nix-file-conventions.md`.
- Small, single-concern commit. Rationale in the message, not in comments.

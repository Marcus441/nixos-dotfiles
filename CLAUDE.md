# CLAUDE.md — Dendritic Nix configuration

This repository follows **the dendritic pattern** — an aspect-oriented approach
where every Nix file is a flake-parts module organized by feature (aspect), not
by configuration class. If a change would violate an invariant, stop and say so
— the invariants are the whole value of this structure, and a single exception
metastasises.

§8 lists where the repo does **not yet** satisfy its own invariants. Read it
before concluding that existing code is an example to copy.

| Host | Archetype | Session | Platform |
| --- | --- | --- | --- |
| `swift5` | laptop | dwl (Wayland, minimalist) | `x86_64-linux` |
| `gpc` | gaming rig | Hyprland | `x86_64-linux` |
| `UM790pro` | dev machine, primary | Hyprland | `x86_64-linux` |
| `mbp` | laptop | — | `aarch64-darwin`, **planned** |

User is `marcus`. Six build targets: three
`nixosConfigurations.<host>.config.system.build.toplevel` and three
`homeConfigurations."marcus@<host>".activationPackage`.

**dwl, not dwm.** dwl is the Wayland compositor. Nothing here is X11.

## 1. Invariants

1. **Every `.nix` file under `modules/` is a flake-parts module.** One
   interpretation, always.
2. **`flake.nix` is a manifest.** Inputs + `mkFlake` + `import-tree`. No logic.
3. **One file = one concern, across every class and aspect it touches.** One
   file declaring several memberships is the merge working as intended.
4. **File paths name the feature but carry no system-meaning.** Never a class,
   host, aspect, or "type". Directories are navigation, not structure.
5. **No `specialArgs` / `extraSpecialArgs`.** Closure over flake-parts `config`,
   or `_module.args` injected by the host wiring.
6. **No manual import lists** except the host wiring. `import-tree` finds the rest.
7. **Aspects are host-agnostic and platform-agnostic.** Machine facts live at
   the host.

Full prose, file exemplars, directory test: `.claude/rules/nix-file-conventions.md`.

## 2. Mental model

flake-parts is the *top-level configuration*; every file participates in one
evaluation. Class modules are not imported from paths — they are **option
values** under `flake.modules.<class>.<aspect>`, typed `deferredModule`, and
those attrsets **merge**. The merge runs both ways: **many files → one aspect**
(grow a feature by adding a file, never editing a list) and **one file → many
aspects** (the direction that gets forgotten). The unit of **concern** is the
*file*; the unit of **applicability** is the *aspect*. Neither contains the other.

## 3. Naming aspects

An aspect is a **decision or a capability**, never a magnitude and never a host
class.

- Good: `hyprland`, `dwl`, `gaming`, `nvidia`, `laptop`, `dev`.
- Bad: `maximal`, `minimal`, `heavy`, `extras` — magnitude names rot.
- Bad: `desktop-machine`, `workstation` — a host archetype, not a concern.

**An aspect earns its existence when some host says no.** If all hosts always
take it, it is `core`. Intent vs implementation (option namespace in `core` +
variant aspects): the **add-feature** skill, `.claude/rules/sharing-values.md`.

## 4. Layout

Descriptive, not normative. The generator does not care where any file lives.

```
flake.nix                    # inputs + mkFlake + import-tree. Rarely touched.
modules/
  aspects.nix                # declares flake.modules and aspectRequires options
  hosts/generator.nix        # the ONE permitted central wiring point
  hosts/record.nix           # the typed host record the generator consumes
  hosts/<hostname>.nix       # what this machine IS: aspects + machine facts
  <concern>.nix              # declares its own aspect membership
  <intent>/                  # implementations of one intent, in different aspects
  **/_*                      # ignored by import-tree (hasInfix "/_" on full path)
```

**Prohibited:** `nixos/`, `home/`, `darwin/` (encode class — Inv. 4 inverted);
`pkgs/`, `overlays/`, `profiles/` (break feature closure); `lib/` (not a
flake-parts module — Inv. 1).

**Permitted:** anything whose name does **not** predict the aspect or class of
every file inside. `filemanager/` is fine; `hyprland/` holding only `hyprland`
files is not.

## 5. Ordering and store paths

Order is the one thing about this structure that reaches a derivation hash.

- **Import order** is a depth-first walk, per-directory alphabetical.
- **Aspect order in a host's list is load-bearing** — merge order → `buildEnv`
  order → derivation hash. Splitting an aspect? Put the new names where the old
  one sat.
- **Only relative order of files contributing to the same aspect matters.**

A working model, not a mechanism. **Measure; do not predict** — recipe in
`.claude/rules/structural-verification.md`.

## 6. Class placement

| Goes in `homeManager` | Goes in `nixos` / `darwin` |
| --- | --- |
| shell, prompt, editor, git, terminal | services, daemons, systemd/launchd units |
| user packages, dotfiles, keybindings | users, boot, filesystems, networking |
| theming, fonts config, cursor | compositor/session registration, PAM |

**Default to `homeManager`. Justify the exception.** Home Manager is
standalone; `mbp` does not exist yet, so every line in `nixos` that could have
been `homeManager` is a line to port later. See `.claude/rules/host-wiring.md`
and `.claude/rules/perSystem-platform.md`.

## 7. Hazards and verification

- **Every *file* is evaluated once** — a syntax error anywhere breaks every
  host. But an **aspect's contents are only evaluated by hosts that take it.**
- **Eval-time vs config-time** — `mkIf` gates the value but still evaluates it.
- **`config` shadowing** inside `flake.modules.*`; **an interpolation at column
  0** reindents a whole generated file. Detail for these and the above:
  `.claude/rules/hazards-detail.md`.
- **Colour hazards** (base16 vs base24 over ANSI, `reset`):
  `.claude/rules/theming-hazards.md`. **`windowTags`**, many setters one
  reader: `.claude/rules/window-tags.md`.
- **`git add -A` before every `nix` command** (flakes see only tracked files),
  **never switch** (build only — the human switches), and **never `nix flake
  update`** (it moves pins). Hooks enforce all three.
- **Build on `UM790pro`.** Hyprland closures on `swift5` drag the chain onto
  the laptop.

Do not claim a config builds without having built it. `nixos-rebuild build`
covers only three of six targets — use `verify.sh`.

```bash
./scripts/verify.sh build        # all six targets — the real check
nix flake check                  # cheap eval sweep
./scripts/verify.sh <ref>        # structural: prove nothing changed but order
```

## 8. Known divergences

**This is a ratchet, not a ledger:** if a task touches a file listed here,
migrate it in the same change, or state why not. Item numbers are stable
identities — closed items are deleted and survivors keep their numbers.

7. **No darwin.** `systems = ["x86_64-linux"]`; `mbp` is planned, not present.

## 9. Anti-patterns

| Anti-pattern | Why |
| --- | --- |
| `nixos/`, `home/`, `darwin/` directories | Paths encode class (Inv. 4) |
| `pkgs/`, `overlays/` directories | Breaks feature closure |
| `lib/` directory of helpers | Not a flake-parts module (Inv. 1) |
| `imports = [ ./foo.nix ]` inside `modules/` | `import-tree` already loaded it (Inv. 6) |
| `specialArgs = { inherit self inputs; }` | Closure or `_module.args` (Inv. 5) |
| `_` to group related files | `/_` is for non-modules only (§4) |
| Aspect named `maximal` / `minimal` | Magnitude, not a decision (§3) |
| `mkEnableOption` per aspect | Hosts compose by taking aspects, not by enabling |
| One aspect branching between dwl and Hyprland | Option namespace + variant aspects (§3) |
| Aspect reading `config.networking.hostName` | Aspects are host-agnostic (Inv. 7) |
| Editing three files to add one feature | Wrongly decomposed (Inv. 3) — but one file installing into several aspects is not this |

## 10. Working style

- **Structural change?** Use the **structural-change-checklist** skill before
  committing. Structural = moving/renaming/regrouping files,
  adding/splitting/renaming aspects, changing a host's aspect list, editing the
  generator or `aspects.nix`.
- **Prefer adding a file to editing one**, especially when extending an aspect.
  Do not add an enable flag; split into two files and let hosts differ by aspect.
- **Small, single-concern commits.** Rationale in the commit message.
- **A `.nix` file gets one kind of comment, and only one.** A one-line
  `# load-bearing: docs/decisions/<area>.md#anchor`, at a value whose change
  breaks something non-obviously. Nothing else: no section banners, no
  restating the line below, no commented-out alternatives. The reasoning goes
  in `docs/` — `conventions/` for what recurs across files, `decisions/` for
  why one file made its call — and **changing a decision means changing its
  entry in the same commit**. A register that drifts is worse than none.
- **Text inside a `''` block is content, not a comment.** A `#` there ships into
  the generated bashrc, tmux.conf or C header, so adding or removing one moves a
  store path. **Label what the block produces; never argue for a value.** A
  label lets a reader skip the block — worth it where the syntax hides the
  output, as PS1 escapes do. **Two lines is the cap:** needing a third means it
  is an argument, and arguments belong in `docs/`. A PostToolUse hook enforces
  the cap across `#`, `//` and `/* */`.
- **No unrequested changes.** No package bumps, no deprecation fixes, no
  reformatting files the current task doesn't touch.
- **Do not introduce a framework** (`den`, `snowfall`, `flake-file`,
  `easy-hosts`) without being asked. `flake-parts` and `import-tree` only.
- **Do not re-propose:** Quickshell; a dwl host taking `waybar`/`walker`;
  Waybar's opt-in shape; dwl-bar's shape; re-enabling `statix` `repeated_keys`;
  moving the five ex-`common-packages` tools out of `nixos`. Rationale:
  `.claude/rules/settled-decisions.md` and git history.
- **Unresolved — ask rather than inventing:** secrets management (sops-nix vs
  agenix), and whether custom packages should be flake outputs, overlay
  entries, or both.
- **Finished plans go to git history.** Cite a §-number or commit hash, never a
  plan filename.
- **If a request genuinely doesn't fit the pattern,** say so and give options
  with their costs. Do not silently bend an invariant.
- **When something breaks after a switch, diagnose the live system before
  editing Nix.** Check for masking, shadowing, and stale user-level state first.

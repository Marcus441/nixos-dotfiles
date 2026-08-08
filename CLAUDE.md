# CLAUDE.md — Dendritic Nix configuration

This repository follows **the dendritic pattern** — an aspect-oriented
approach where every Nix file is a flake-parts module organized by feature
(aspect), not by configuration class. Read §1 before editing anything. If a
change would violate an invariant, stop and say so — the invariants are the
whole value of this structure, and a single exception metastasises.

§12 lists where the repo does **not yet** satisfy its own invariants. Read it
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

---

## 1. Invariants

1. **Every `.nix` file under `modules/` is a flake-parts module.** Not a NixOS
   module, not a home-manager module, not a package expression, not a helper
   library. One interpretation, always.
2. **`flake.nix` is a manifest.** Inputs plus `mkFlake` plus `import-tree`. No
   configuration logic. Edited only to add an input.
3. **One file = one concern, across every class and every aspect it touches.**
   A single file may declare multiple aspects and multiple classes — that is
   the merge working as intended (§2). The violation is one concern spread
   across several files.
4. **File paths name the feature but carry no system-meaning.** A path never
   encodes a class, a host, an aspect, or a "type" — the module system does
   not read it. Files move freely; directories are navigation, not structure.
5. **No `specialArgs` / `extraSpecialArgs`.** Static values cross by closure
   over the flake-parts `config`; host-varying values arrive as `_module.args`
   injected by the host wiring (§8).
6. **No manual import lists** except the host wiring (§4). `import-tree`
   discovers everything else.
7. **Aspects are host-agnostic and platform-agnostic.** Machine facts —
   hostname, `hostPlatform`, `stateVersion`, disk layout, monitor geometry —
   live at the host.

---

## 2. Mental model

flake-parts is the *top-level configuration*. Every file participates in that
one evaluation. NixOS / darwin / home-manager modules are not imported from
paths — they are stored as **option values** under
`flake.modules.<class>.<aspect>`, typed as `deferredModule`, and those
attribute sets **merge**.

That merge runs in both directions:

- **Many files → one aspect.** Growing a feature means *adding a file*, never
  editing a list.
- **One file → many aspects.** A single concern can contribute to different
  aspects and several classes at once. This is the direction that gets
  forgotten.

Two independent axes: the unit of **concern** is the *file*; the unit of
**applicability** is the *aspect*. Neither contains the other.

**Read before writing a new file:**
- `modules/filemanager/thunar.nix` — one concern, two aspects, both classes.
  **This is the file to copy.**
- `modules/tmtheme.nix` — provider/consumer split: declares `desktop.syntaxTheme`
  in `core`, read by `bat.nix` and `yazi.nix`.
- `modules/ccache.nix` — declares `dev` beside files declaring `core`. Nothing
  about its location says which. Inv. 4 demonstrated.
- `modules/dwl.nix`, `modules/hyprland.nix` — one concern spanning both `nixos`
  and `homeManager` in one file.

**21 of the 94 files that declare an aspect declare more than one** aspect or
class. The single-aspect file is the majority but not the model — copying an
arbitrary neighbour reproduces the majority and misses the second direction of
the merge. Check §12 before treating any file as an example.

> **Recount when a file gains or loses a membership** — these two numbers go
> stale silently, and nothing in the build checks them:
> ```bash
> for f in $(find modules -name '*.nix' ! -path '*/_*'); do
>   grep -ohE 'flake\.modules\.[a-zA-Z]+\.[a-zA-Z0-9_-]+' "$f" | sort -u | wc -l
> done | awk '$1>=2' | wc -l      # drop the awk for the 94
> ```

> **Note on `deferredModule`:** The dendritic README warns against using *only*
> flake-parts' built-in `flake.modules` without declaring typed options (the
> "Not declaring options" anti-pattern). `modules/aspects.nix` declares the
> `flake.modules` and `aspectRequires` options with `deferredModule` type,
> which is the recommended approach.

---

## 3. Naming aspects

An aspect is a **decision or a capability**, never a magnitude and never a host
class.

- Good: `hyprland`, `dwl`, `gaming`, `nvidia`, `laptop`, `dev`.
- Bad: `maximal`, `minimal`, `heavy`, `extras` — magnitude names rot.
- Bad: `desktop-machine`, `workstation` — that is a host archetype, not a
  concern.

**An aspect earns its existence when some host says no.** If all hosts always
take it, it is `core`. A bad name is cheap to fix — renaming an aspect only
moves store paths if it changes a host's aspect list position (§5).

### Intent vs implementation

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

### `windowTags`: many setters, one reader

`windowTags.<tag> = [<class regex>]` in `core`, appended to by every file that
installs a window, read by `hyprland-rules.nix`. The namespace is in `core`
because `core` files set it and would otherwise fail on swift5. A dwl host
carries the value with no reader — measured: swift5 builds byte-identical.

### A tool invoked by bare name must be installed by every aspect that invokes it

`brightnessctl.nix` declares **both** `hyprland` and `laptop`, installing the
same package twice. That is correct: hypridle and Hyprland binds invoke it by
bare name, so it must be on `PATH` wherever those sessions run. This is not an
Inv. 3 failure — it is one file declaring several memberships (the merge
working as intended). Where the consumer can hold a store path instead
(`dwl.nix` interpolates it into C code), prefer that.

---

## 4. Layout and host wiring

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

**Prohibited directories:** `nixos/`, `home/`, `darwin/` (encode class — Inv. 4
inverted); `pkgs/`, `overlays/`, `profiles/` (break feature closure); `lib/`
(not a flake-parts module — Inv. 1).

**Permitted directories:** anything where the name does **not** predict the
aspect or class of every file inside. `filemanager/` (two implementations of
one intent, different aspects) is fine. `hyprland/` holding only `hyprland`
files would not be — the directory is redundant with the aspect name. **`core`
does not count toward "several aspects"** — every host takes `core`.

Test: if every file inside declares the same declining aspect, the directory is
redundant and the files should be flat. If the files span declining aspects,
the directory is pure navigation and is fine.

`/_` is for non-modules only: values consumed by `import`, derivations consumed
by `callPackage`, dormant code. **It is not a grouping mechanism.**

---

## 5. Ordering and store paths

Order is the one thing about this structure that reaches a derivation hash.

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
`_file`. **Measure with the recipe in §10; do not predict.**

---

## 6. Task recipes

### Add a feature
1. Name the aspect after the decision or capability (§3).
2. Create `modules/<concern>.nix`. Declare membership for every class and
   aspect it touches.
3. Add the aspect name to the relevant hosts.
4. Verify (§10).

### Extend a feature
Add a **new file** targeting the same `flake.modules.<class>.<aspect>`. Do not
add an enable flag — split into two files and let hosts differ by aspect.

### Add a host
Add `modules/hosts/<hostname>.nix`. The generator rejects a `hostname` that
disagrees with its attribute, aspect names that resolve in no class, and an
unmet `aspectRequires`. **When an aspect depends on another, declare
`aspectRequires` in the file that creates the dependency** — a central table
would not know when a file stops reading.

### Add a package or overlay
`perSystem.packages.<name>` in the file that uses it. Never in a `pkgs/`
directory.

> **Trap:** home configs are built on `nixpkgs.legacyPackages.${system}`, so an
> overlay declared in the flake reaches NixOS and **silently does not exist for
> Home Manager.** `callPackage` directly or change the generator deliberately.

### Add a flake input
Edit `flake.nix`. **Never run `nix flake update`** — adding an input and
running `nix flake lock` is fine; moving existing pins is not.

---

## 7. Class placement — and the Mac

`mbp` does not exist yet and `systems` is `["x86_64-linux"]`. Every line put in
`nixos` that could have lived in `homeManager` is a line to be ported later.

Home Manager is **standalone** — `homeConfigurations."marcus@<host>"`,
activated separately. Do not convert it to `home-manager.nixosModules.home-manager`.

| Goes in `homeManager` | Goes in `nixos` / `darwin` |
| --- | --- |
| shell, prompt, editor, git, terminal | services, daemons, systemd/launchd units |
| user packages, dotfiles, keybindings | users, boot, filesystems, networking |
| theming, fonts config, cursor | compositor/session registration, PAM |

**Default to `homeManager`. Justify the exception.**

Cross-platform intents (`launcher`, `screenshot`, `clipboard`, `lock`) are
option namespaces in `core`, set by `hyprland` and `dwl`. `notifications` is
deliberately **not** one — mako serves both sessions from one file and nothing
invokes it by command.

**`perSystem` is where platform breakage bites early.** Adding `aarch64-darwin`
to `systems` will immediately fail any Linux-only `perSystem.packages`. Exclude
by attribute, not by value — `mkIf` gates the value but still evaluates it:

```nix
packages = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux { foo = …; };  # right
packages.foo = lib.mkIf pkgs.stdenv.hostPlatform.isLinux …;                  # wrong
```

---

## 8. Sharing values

In order of preference:

1. **`let` binding** — when only that file needs it.
2. **A flake-parts option** — when other files need it. Capture the flake-parts
   `config` in an outer `let`; inside `flake.modules.*`, `config` is the
   *guest* config, not flake-parts'. Getting this wrong produces infinite
   recursion, not a clear error.
3. **`_module.args`, injected by the host wiring** — for values that vary per
   host (monitors, hostname). An aspect is a single value shared by every host
   that takes it — there is nothing for a closure to specialise on (Inv. 7).

**`_module.args` cannot compute `imports`** — resolving imports happens before
config, so using an injected arg to decide imports is infinite recursion. If
an import needs to depend on a host fact, that fact is a *decision*, and
decisions belong in the host's aspect list.

Forbidden: `specialArgs`, `extraSpecialArgs`, threading `self`/`inputs` into a
nested evaluation, importing a module file by path to call a function.

---

## 9. Hazards

- **Aspect elements are `types.deferredModule`.** Switching from `types.raw`
  left all six targets byte-identical on the flattened tree. The change buys
  provenance across all files `import-tree` loads. Re-run §10's full check if
  you change the element type again.
- **`config` shadowing** inside `flake.modules.*` — see §8.
- **ANSI carries base16; base24 is only reachable as hex.** `foot.nix` renders
  the standard base16 slot mapping from `desktop.colors16` (the `base0*` subset
  of `desktop.colors`), so a program asking for *the base16 theme* now gets
  what it asserts — ANSI 9 is base09. The corollary is that `base10`–`base17`
  cannot travel through ANSI at all: a consumer wanting one reads
  `desktop.colors` and hands over hex, which is why `qt.nix` does. The reason
  `bat.nix` and `filemanager/yazi.nix` share `desktop.syntaxTheme` is
  unchanged: syntect takes a tmTheme, not ANSI.
- **`reset` is a value that only survives being drawn.** yazi's status bar
  reads colours back and transposes them. Check whether anything reads a colour
  back before choosing one.
- **Every *file* is evaluated once** — a syntax error anywhere breaks every
  host. But an **aspect's contents are only evaluated by hosts that take it.**
- **Eval-time vs config-time.** `lib.mkIf pkgs.stdenv.isLinux { … pkgs.grim … }`
  still evaluates `pkgs.grim`. Guard the reference, not just the config.
- **An interpolation at column 0 reindents a whole generated file.** `''`
  strips the least indentation; a line beginning `${...}` has none.
- **`git add -A` before every `nix` command.** Flakes see only tracked files.
- **Never switch.** Build only — the human switches.
- **Build on `UM790pro`.** Building Hyprland closures on `swift5` drags the
  whole chain onto the laptop.

---

## 10. Verification

Do not claim a config builds without having built it.

```bash
./scripts/verify.sh build        # all six targets — the real check
nix flake check                  # cheap eval sweep
```

`nixos-rebuild build` covers only three of six targets. Use `verify.sh`.

For structural changes, prove nothing changed but order:

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

  oldt=$(nix build --no-link --print-out-paths \
         "../dotfiles-prev#nixosConfigurations.$h.config.system.build.toplevel")
  newt=$(nix build --no-link --print-out-paths \
         ".#nixosConfigurations.$h.config.system.build.toplevel")
  diff -rq "$oldt/etc" "$newt/etc" 2>&1 | grep -v "^diff:.*No such file"
done

git worktree remove ../dotfiles-prev
```

`swift5` takes neither Hyprland nor `apps` — a useful control for work on those.

**Bisect eval errors** by temporarily renaming a file to `_name.nix` —
`import-tree` skips it. Halve the tree until the build recovers. Undo before
committing.

Inspect merged aspects: `nix repl` → `:lf .` →
`config.flake.modules.homeManager.hyprland`.

---

## 11. Anti-patterns

| Anti-pattern | Why |
| --- | --- |
| `nixos/`, `home/`, `darwin/` directories | Paths encode class (Inv. 4) |
| `pkgs/`, `overlays/` directories | Breaks feature closure |
| `lib/` directory of helpers | Not a flake-parts module (Inv. 1) |
| `imports = [ ./foo.nix ]` inside `modules/` | `import-tree` already loaded it (Inv. 6) |
| `specialArgs = { inherit self inputs; }` | Closure or `_module.args` (Inv. 5, §8) |
| `_` to group related files | `/_` is for non-modules only (§4) |
| Aspect named `maximal` / `minimal` | Magnitude, not a decision (§3) |
| `mkEnableOption` per aspect | Hosts compose by taking aspects, not by enabling |
| One aspect that branches between dwl and Hyprland | Option namespace + variant aspects (§3) |
| Aspect reading `config.networking.hostName` | Aspects are host-agnostic (Inv. 7) |
| Editing three files to add one feature | Wrongly decomposed (Inv. 3) — but one file installing into several aspects is not this |

---

## 12. Known divergences

**This is a ratchet, not a ledger:** if a task touches a file listed here,
migrate it in the same change, or state why not. Item numbers are stable
identities — closed items are deleted and survivors keep their numbers.

7. **No darwin.** `systems = ["x86_64-linux"]`; `mbp` is planned, not present.

---

## 13. Working style

- **Before committing a structural change**, self-check against §1
  (invariants) and §11 (anti-patterns). If a change would violate an
  invariant, stop and say so — do not silently bend the rule. Structural =
  moving/renaming/regrouping files, adding/splitting/renaming aspects,
  changing a host's aspect list, editing the generator or `aspects.nix`.
- **Verify with `scripts/verify.sh`** (§10). For structural changes, run the
  diff-closures recipe to prove nothing changed but order. Do not claim a
  config builds without having built it.
- **Small, single-concern commits.** Rationale in the commit message, not
  comments. Terse comments — explain *why*, never *what*.
- **Prefer adding a file to editing one**, especially when extending an aspect.
- **No unrequested changes.** No package bumps, no deprecation fixes, no
  reformatting files the current task doesn't touch.
- **The five ex-`common-packages` tools stay in `nixos`.** Deliberately
  accepted, not a divergence — the move to `home.packages` would be a
  behavioural change. Do not "fix" it.
- **`statix.toml` disables `repeated_keys`, and it stays disabled.** The rule
  flags the best files (§2 exemplars) and untouchable hardware configs. Do not
  re-enable.
- **Do not introduce a framework** (`den`, `snowfall`, `flake-file`,
  `easy-hosts`) without being asked. This repo depends on `flake-parts` and
  `import-tree` only.
- **Deliberately deferred — do not propose unasked:** Quickshell; a dwl host
  taking `waybar`/`walker` (four blockers in git history).
- **Waybar's opt-in shape is finished; do not re-propose.** `waybar` and
  `wleave` are separate aspects, `aspectRequires.waybar = ["hyprland"]` rejects
  dwl hosts, `waybar.nix` embeds wleave gated on `powerMenu.command`.
- **dwl's bar is `dwl-bar`; its shape is settled.** `dwl.nix` declares `dwl.bar`
  in `homeManager.dwl`; `bar/dwl-bar.nix` sets it and declares
  `aspectRequires.dwl-bar = ["dwl"]`. Silent failure by construction — a dwl
  host without `dwl-bar` builds a working bar-less dwl.
- **Finished plans go to git history.** Cite a §-number or commit hash, never a
  plan filename.
- **Unresolved — ask rather than inventing:** secrets management (sops-nix vs
  agenix), and whether custom packages should be flake outputs, overlay
  entries, or both.
- **If a request genuinely doesn't fit the pattern,** say so and give options
  with their costs. Do not silently bend an invariant.
- **When something breaks after a switch, diagnose the live system before
  editing Nix.** Check for masking, shadowing, and stale user-level state first.

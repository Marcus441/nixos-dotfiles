# CLAUDE.md — Dendritic Nix configuration

This repository follows **the dendritic pattern**. Read §1 before editing anything. If a
change would violate an invariant, stop and say so rather than working around it — the
invariants are the whole value of this structure, and a single exception metastasises.

§11 lists where the repo does **not yet** satisfy its own invariants. Read it before
concluding that existing code is an example to copy.

| Host | Archetype | Session | Platform |
| --- | --- | --- | --- |
| `swift5` | laptop | dwl (Wayland, suckless) | `x86_64-linux` |
| `gpc` | gaming rig | Hyprland | `x86_64-linux` |
| `UM790pro` | dev machine, primary | Hyprland | `x86_64-linux` |
| `mbp` | laptop | — | `aarch64-darwin`, **planned** |

User is `marcus`. Six build targets today: three
`nixosConfigurations.<host>.config.system.build.toplevel` and three
`homeConfigurations."marcus@<host>".activationPackage`.

**dwl, not dwm.** dwl is the Wayland compositor. Nothing here is X11.

---

## 1. Invariants

1. **Every `.nix` file under `modules/` is a flake-parts module.** Not a NixOS module, not
   a home-manager module, not a package expression, not a helper library. One
   interpretation, always.
2. **`flake.nix` is a manifest.** Inputs plus `mkFlake` plus `import-tree`. No
   configuration logic. Edited only to add an input.
3. **One file = one concern, across every class and every aspect it touches.** If adding
   one feature means editing three files, the decomposition is wrong.
4. **File paths carry no meaning.** A path never encodes a class, a host, an aspect, or a
   "type". Paths are navigation; membership is declared in the file. Files move freely.
5. **No `specialArgs` / `extraSpecialArgs`.** Static values cross by closure over the
   flake-parts `config`; host-varying values arrive as `_module.args` injected by the host
   wiring. See §7.
6. **No manual import lists** except the host wiring (§4). `import-tree` discovers
   everything else.
7. **Aspects are host-agnostic and platform-agnostic.** Machine facts — hostname,
   `hostPlatform`, `stateVersion`, disk layout, monitor geometry — live at the host.

---

## 2. Mental model

flake-parts is itself a module-system evaluation: the *top-level configuration*. Every
file participates in that one evaluation. NixOS / darwin / home-manager modules are not
imported from paths — they are stored as **option values** under
`flake.modules.<class>.<aspect>`, and those attribute sets **merge**.

That merge is the whole pattern, and it runs in both directions:

- **Many files → one aspect.** Growing a feature means *adding a file*, never editing a
  list.
- **One file → many aspects.** A single concern can contribute different pieces to
  different aspects, and to several classes at once.

The second direction is the one that gets forgotten. It gives you two independent axes:

- the unit of **concern** is the *file*
- the unit of **applicability** is the *aspect*

Neither contains the other, which is why no single directory tree can express both. Stop
asking "which folder does this belong in" — ask "what does this concern contribute, and to
whom".

```nix
# modules/font.nix — one concern, three audiences, one file
{
  flake.modules.homeManager.core = [
    { options.desktop.font = { /* name, size */ }; }
  ];

  flake.modules.homeManager.stylix = [
    ({config, ...}: { stylix.fonts.monospace.name = config.desktop.font.name; })
  ];

  flake.modules.homeManager.palette = [
    { home.packages = [ /* fonts */ ]; fonts.fontconfig.enable = true; }
  ];
}
```

A host is a short list of aspect names. Reading a host file should tell you what the
machine **is**.

### Read these before writing a new file

- `modules/font.nix` — the sketch above, as an actual file: `core` declares the option,
  `palette` installs the fonts, `stylix` hands the same option to stylix. One concern,
  three audiences. **This is the file to copy.**
- `modules/mako.nix` — the same daemon under two theming regimes, one file.
- `modules/ccache.nix` — declares `dev` while sitting beside files that declare `core`.
  Nothing about its location says which. Invariant 4, demonstrated.
- `modules/dwl.nix`, `modules/hyprland.nix` — one concern spanning both `nixos` and
  `homeManager` in one file. Invariant 3, half-demonstrated.

Those four aside, most files still contribute to exactly one aspect. Copying an arbitrary
nearby file will reproduce the divergences in §11 — check there first.

---

## 3. Naming aspects

An aspect is a **decision or a capability**, never a magnitude and never a host class.

- Good: `hyprland`, `dwl`, `gaming`, `nvidia`, `laptop`, `dev`, `stylix`, `palette`.
- Bad: `maximal`, `minimal`, `heavy`, `extras` — magnitude names rot the first time you
  want one member without the others, and then the name lies.
- Bad: `desktop-machine`, `workstation` — that is a host archetype, not a concern. The
  archetype is the *list*, not an entry in it.

**An aspect earns its existence when some host says no.** If all hosts always take it, it
is `core`. Do not make every package an aspect: files already give you per-tool
granularity, and per-tool *selection* only turns each host into a duplicated manifest.

### Intent vs implementation

Two compositors share ideas (gaps, mod key, keybinding philosophy) but no code. Do **not**
build one `tiling-wm` aspect that branches internally, and do not force one aspect name to
mean two implementations — both files would declare the same attribute and merge into any
host taking it.

Instead: the portable part is an **option namespace**, the implementations are **separate
aspects**.

```nix
# modules/tiling.nix — portable intent, no implementation
{ flake.modules.homeManager.core = [ { options.tiling = { /* gaps, modKey */ }; } ]; }

# modules/hyprland.nix        reads config.tiling, declares flake.modules.*.hyprland
# modules/dwl.nix             reads config.tiling, declares flake.modules.*.dwl
```

Hosts take `hyprland` **or** `dwl`. Genuine overlap (locking, notifications, portals,
clipboard) becomes its own aspect that both take.

---

## 4. Layout and host wiring

Descriptive, not normative. Invariant 4 means the generator does not care where any file
lives — this is where things happen to sit, not a schema to pattern-match a new
`modules/wayland/` tree onto.

```
flake.nix                    # inputs + mkFlake + import-tree. Rarely touched.
modules/
  aspects.nix                # declares the flake.modules option
  hosts/generator.nix        # the generator: the ONE permitted central wiring point
  hosts/<hostname>.nix       # what this machine IS: archetype aspects + machine facts
  display/                   # typed monitor options + renderers (flake.lib.monitors)
  <concern>.nix              # a concern; declares its own aspect membership
  <concern>/*.nix            # a concern too large for one file
  **/_*                      # ignored by import-tree (`/_` anywhere in the path)
```

**Import order is a depth-first walk, per-directory alphabetical.** From import-tree's
source: `builtins.attrNames` returns names sorted, and directories recurse inline at their
own name's position. Component-wise path order — not a global basename sort. The `/_`
filter is `hasInfix "/_"`, a literal substring test on the full path, which is exactly the
"anywhere in the path" rule above.

**What reaches store paths is narrower than that.** A host's `home.packages` is the
concatenation over its *aspect list*, in host-list order; within each aspect, contributions
land in discovery order. So only the **relative order of files contributing to the same
aspect** matters. Interleaving files of different aspects is invisible — the aspect list
already separated them.

That predicts both things Step 0 measured: relocating ~70 files was byte-identical because
a total flatten preserves within-aspect relative order, while renaming `monitors.nix` moved
its package from position 1 to 11 because it changed that file's rank among its own
aspect's siblings. It is also why a *partial* move is not automatically free.

Treat this as a working model, not a mechanism. A controlled probe produced a definition
order this model does not predict, so discovery order is not strictly positional. **Measure
with the recipe below; do not predict.**

There is **no** `nixos/`, `home/`, `darwin/`, `pkgs/`, `overlays/`, or `profiles/`
directory. Creating one is a structural regression — say so instead of doing it.

Grouping for navigation is fine — Invariant 4 says paths carry no *meaning*, not that they
must be flat. **A directory is safe when its name would be a bad aspect name and the files
inside span more than one aspect.** `font/` passes: `font` names no decision, and its files
serve core, stylix and palette. A `system/` directory holding every `nixos.core` file fails
both halves — the path would predict class and membership exactly, which is `nixos/` under
another name.

Host files declare archetype and machine facts only:

```nix
{
  hosts.gpc = {
    hostname = "gpc";
    system = "x86_64-linux";
    stateVersion = "25.11";
    aspects = ["core" "hyprland" "stylix" "gaming" "nvidia"];

    hardware = ../../hosts/gpc/hardware-configuration.nix;
    monitors = [ { name = "DisplayPort-1"; width = 2560; height = 1440; refresh = 144; } ];
  };
}
```

**Aspect order in that list is load-bearing.** It determines module merge order, which
determines `buildEnv` order, which reaches derivation hashes. Reordering is a real change,
not a cosmetic one.

`hosts/<h>/hardware-configuration.nix` is the sole exception to Invariant 4: it is
machine-generated, **never edit it**, and it is not regenerable without physical access.

### `/_` is for non-modules only

`import-tree` skips any path containing `/_`, and collects only `.nix` files — so asset
directories need no underscore at all. Use `/_` for exactly three things:

1. values consumed by `import` rather than as modules,
2. derivations consumed by `callPackage`,
3. dormant code.

It is **not** a grouping mechanism. Grouping is what aspect names are for. If you are
reaching for `_` to tidy a directory, you want an aspect.

---

## 5. Task recipes

### Add a feature

1. Name the aspect after the decision or capability (§3).
2. Create `modules/<concern>.nix`.
3. Declare membership for every class and aspect it touches. Omitting `darwin` is normal
   and correct for Linux-only features.
4. Add the aspect name to the relevant hosts.
5. Verify (§9).

### Extend a feature

Add a **new file** targeting the same `flake.modules.<class>.<aspect>`. Do not grow one
file past readability, and do not add an enable flag to gate new behaviour — split into
two files and let hosts differ by which aspect they take.

### Add a host

Add `modules/hosts/<hostname>.nix`. The generator produces both output sets from the
attribute name, so they cannot drift; it rejects a `hostname` that disagrees with its
attribute, and rejects aspect names that resolve in no class.

### Add a package or overlay

`perSystem.packages.<name>` in the file that uses it. A patched dwl belongs beside the
config that consumes it, never in a `pkgs/` directory.

> **Trap:** home configs are built on `nixpkgs.legacyPackages.${system}`, so **an overlay
> declared in the flake reaches NixOS and silently does not exist for Home Manager.** If a
> home module needs the package, `callPackage` it directly or change the generator
> deliberately — that change moves every home store path and is its own commit.

### Add a flake input

`flake.nix` is the one file where a central edit is correct. Then use it via the `inputs`
module argument. **Never run `nix flake update`** — adding an input and running
`nix flake lock` is fine; moving existing pins is not.

---

## 6. Class placement — and the Mac

`mbp` does not exist yet and `systems` is currently `["x86_64-linux"]`. The constraint
still binds today, because **every line put in `nixos` that could have lived in
`homeManager` is a line to be ported later.**

Home Manager here is **standalone** — `homeConfigurations."marcus@<host>"`, activated
separately. That is an asset for darwin: the same home aspects activate on macOS with no
NixOS underneath. Do not convert it to `home-manager.nixosModules.home-manager`.

| Goes in `homeManager` | Goes in `nixos` / `darwin` |
| --- | --- |
| shell, prompt, editor, git, terminal | services, daemons, systemd/launchd units |
| user packages, dotfiles, keybindings | users, boot, filesystems, networking |
| theming, fonts config, cursor | compositor/session registration, PAM |
| per-user secrets | system fonts, security, `system.defaults` (darwin) |

**Default to `homeManager`. Justify the exception, not the rule.**

Cross-platform intents worth naming now so the Mac is cheap later: `launcher`,
`screenshot`, `clipboard`, `lock`, `notifications`. Each gets an option namespace plus
per-platform implementation aspects (§3).

**`perSystem` is the one place platform breakage bites early.** Unlike aspect contents,
`perSystem` outputs are evaluated for *every* entry in `systems`. Adding `aarch64-darwin`
will immediately fail any Linux-only `perSystem.packages`. Exclude them **by attribute,
not by value** — `mkIf` gates the value but still evaluates it:

```nix
packages = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {   # right
  foo = pkgs.someLinuxOnlyThing;
};
packages.foo = lib.mkIf pkgs.stdenv.hostPlatform.isLinux pkgs.someLinuxOnlyThing;  # wrong
```

---

## 7. Sharing values

In order of preference:

1. **`let` binding**, when only that file needs it.
2. **A flake-parts option**, when other files need it. Read it by capturing the
   flake-parts `config` in an outer `let` — inside `flake.modules.*`, `config` is the
   *guest* config, not flake-parts':

   ```nix
   {config, ...}:
   let top = config; in {
     flake.modules.homeManager.bar = [
       ({config, ...}: { programs.waybar.style = "background: ${top.palette.bg};"; })
     ];
   }
   ```

   Getting this wrong produces infinite recursion, not a clear error.
3. **`_module.args`, injected by the host wiring**, for values that vary per host
   (monitors, hostname, sensitivity).

   Closure cannot do this — not because the guest evaluation can't see flake-parts values
   (option 2 proves it can; the interpolation happens during flake evaluation, long before
   Home Manager runs), but because **an aspect is a single value shared by every host that
   takes it.** There is nothing for a closure to specialise on. Inv. 7 restated.

**`_module.args` cannot compute `imports`.** Resolving imports happens before config, so
using an injected arg to decide what to import is infinite recursion, not a clear error.
Avoiding exactly this is why `specialArgs` exists in the module system — but do not
reintroduce it. If an import needs to depend on a host fact, that fact is a *decision*, and
decisions belong in the host's aspect list.

Forbidden: `specialArgs`, `extraSpecialArgs`, threading `self`/`inputs` into a nested
evaluation to reach a value, importing a module file by path to call a function out of it.

---

## 8. Hazards

- **Aspect elements are `types.deferredModule`.** They were `types.raw` until Step 1 of
  `REFACTOR.md`, on the grounds that `deferredModule` had been measured to move store
  paths. **That did not reproduce.** On the flattened tree, switching the element type left
  all six targets byte-identical: empty `diff-closures`, no diff under `home-files`, no diff
  under `/etc`. Nothing is claimed here about why the two measurements disagree — the
  earlier one is simply not evidence about this tree.

  What the change buys, measured on the same probe under both types — two files setting
  `programs.bash.historySize` in `core`:

  ```
  raw:             - In `<unknown-file>': 100000
  deferredModule:  - In `…/modules/probe-b.nix, via option
                     flake.modules.homeManager.core."[definition 15-entry 1]"': 100000
  ```

  Provenance across 105 files, which is the whole reason for it.

  The risk this was tested for is elements *vanishing* — a multi-element aspect list
  declared in one file could in principle lose members. `modules/stylix.nix` is the only
  such declaration in the repo (2 elements) and both survived. Note that
  `builtins.length config.flake.modules.…` does **not** detect this; the byte-identity
  block in §9 does. Re-run all three parts of it if you change the element type again.
- **`config` shadowing** inside `flake.modules.*` — see §7.
- **Stylix themes what it detects.** The stylix aspect sets `autoEnable = false` with an
  explicit target list, so a program is themed only if named. Moving a themed program
  between aspects can therefore change its appearance in either direction: into a
  stylix-carrying host it may get themed and silently override an explicit palette; out of
  one it may lose theming entirely. When a program carries its own colours, set
  `stylix.targets.<name>.enable = false` explicitly rather than relying on it not being
  listed. `foot` is the worked example.
- **Every *file* is evaluated once**, at the flake-parts level — so a syntax or eval error
  anywhere breaks every host. But an **aspect's contents are only evaluated by hosts that
  take it**: a `throw` inside `maximal` does not break swift5. Verified, not assumed.
- **Eval-time vs config-time.** Within an aspect a host *does* take,
  `lib.mkIf pkgs.stdenv.isLinux { ... pkgs.grim ... }` still evaluates `pkgs.grim`. Guard
  the reference, not just the config, or split the file. This does **not** mean a
  Linux-only reference in an aspect `mbp` never takes needs guarding — it doesn't.
- **`git add -A` before every `nix` command.** Flakes see only tracked files; skipping
  this gives "path does not exist" for files visibly on disk.
- **Never switch.** No `nixos-rebuild switch`, no `nh os switch`, no `home-manager switch`.
  Build only — the human switches.
- **Build on `UM790pro`.** Building the Hyprland closures on `swift5` drags Hyprland and
  the stylix chain onto the laptop.

---

## 9. Verification

Do not claim a config builds without having built it.

```bash
./scripts/verify.sh build        # all six targets — the real check
nix flake check                  # cheap eval sweep; warns 'unknown flake output modules'
```

`nixos-rebuild build` covers only three of six targets — it never touches
`homeConfigurations`. `nix flake check` does not deeply build them either. Use
`verify.sh`.

For structural changes that reorder modules, prove nothing changed but order:

Run it as one block — every command depends on `$h`, and checking a single host misses
exactly the leaks worth catching:

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

  # A module that vanishes while setting only config adds no package, so the
  # closure is unchanged. The NixOS side needs its own diff.
  oldt=$(nix build --no-link --print-out-paths \
         "../dotfiles-prev#nixosConfigurations.$h.config.system.build.toplevel")
  newt=$(nix build --no-link --print-out-paths \
         ".#nixosConfigurations.$h.config.system.build.toplevel")

  diff -rq "$oldt/etc" "$newt/etc" 2>&1 | grep -v "^diff:.*No such file"
done

git worktree remove ../dotfiles-prev
```

`swift5` takes neither Hyprland nor stylix, so it is a useful control *for work on those* —
a swift5 path that moves during Hyprland work means the change leaked. It is not a blanket
stop condition: plenty of legitimate changes move all three. Know which you are doing.

Because `import-tree` loads everything, an eval error anywhere breaks every host and the
message rarely names the file. **Bisect by temporarily renaming a file to `_name.nix`** —
`import-tree` skips it, and dormant code is a sanctioned use of `/_` (§4). Halve the tree
until the build recovers. Undo before committing.

Inspect generated output rather than asserting it is right. Rendered files live under
`$out/home-files/` (`.config/hypr/hyprland.lua`, `.config/foot/foot.ini`, `.bashrc`) and
`$out/etc/systemd/user/` for NixOS toplevels. `systemd-analyze verify <unit>` catches
broken units before a switch does.

Run `nix build` from the repo root — `.#` resolves against the working directory.

Inspect a merged aspect:

```bash
nix repl
:lf .
config.flake.modules.homeManager.hyprland
```

---

## 10. Anti-patterns

| Anti-pattern | Why |
| --- | --- |
| `nixos/`, `home/`, `darwin/` directories | Paths encode class, not concern (Inv. 4) |
| `pkgs/`, `overlays/` directories | Breaks feature closure; the derivation belongs with its config |
| A `lib/` directory of helpers | A helper library is not a flake-parts module (Inv. 1). Expose the value as an option (§7) |
| `imports = [ ./foo.nix ]` inside `modules/` | `import-tree` already loaded it (Inv. 6) |
| `specialArgs = { inherit self inputs; }` | Closure or `_module.args` (Inv. 5, §7) |
| `_` to group related files | `_` is for non-modules only (§4) |
| An aspect named `maximal` / `minimal` | Magnitude, not a decision (§3) |
| `mkEnableOption` per aspect | Hosts compose by taking aspects, not by enabling |
| One aspect that branches between dwl and Hyprland | Option namespace + variant aspects (§3) |
| Aspect reading `config.networking.hostName` | Aspects are host-agnostic (Inv. 7) |
| Editing three files to add one feature | The concern is wrongly decomposed (Inv. 3) |

---

## 11. Known divergences

The repo does not yet satisfy §1. **This is a ratchet, not a ledger:** if a task touches a
file listed here, migrate that file in the same change, or state plainly why not. Nothing
below is grandfathered, and the count is supposed to fall. See `REFACTOR.md`.

Existing code is therefore **not** a safe template — see the exemplars named in §2.

**Item numbers are stable identities, not positions.** A closed item is deleted and the
survivors keep their numbers, so this list does not necessarily start at 1 and its numbers
are safe to cite. `REFACTOR.md` cites them.

2. **`maximal` is a magnitude name.** `suckless` is gone and `maximal` no longer fuses the
   session or the theming — those left in steps 3 and 4 — so what remains is the heavy app
   set under a name that does not say so. It becomes `apps` in step 7.
7. **No darwin.** `systems = ["x86_64-linux"]`; `mbp` is planned, not present.

---

## 12. Working style

- **Small, single-concern commits.** Rationale goes in the commit message, not in comments.
- **Terse comments.** Explain *why*, never *what*.
- **Prefer adding a file to editing one**, especially when extending an aspect.
- **No unrequested changes.** No package bumps, no deprecation fixes, no reformatting
  files the current task does not touch.
- **Do not introduce a framework** (`den`, `snowfall`, `flake-file`, `easy-hosts`) without
  being asked. This repo depends on `flake-parts` and `import-tree` only.
- **Unresolved — ask rather than inventing a convention:** secrets management (sops-nix vs
  agenix, and where the aspect boundary sits), and whether custom packages should be flake
  outputs, overlay entries, or both. No canonical dendritic answer exists; configs in the
  wild differ. Record the decision here once made.
- **If a request genuinely doesn't fit the pattern,** say so and give two or three options
  with their costs. Do not silently pick the one that bends an invariant.
- **When something breaks after a switch, diagnose the live system before editing Nix.**
  Two real cases, neither a flake bug: stale `~/.config/systemd/user/*.service` symlinks
  left by an old manual `systemctl --user enable`, pointing at garbage-collected store
  paths and silently masking working units; and a drop-in adding a second `ExecStart=` to
  a packaged `Type=dbus` unit, which systemd refuses. Check for masking, shadowing and
  stale user-level state first — a config that builds correctly can still be overridden at
  runtime.

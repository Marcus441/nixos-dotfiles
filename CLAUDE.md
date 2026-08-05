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

```
flake.nix                    # inputs + mkFlake + import-tree. Rarely touched.
modules/
  lib/mk-hosts.nix           # the generator: the ONE permitted central wiring point
  hosts/<hostname>.nix       # what this machine IS: archetype aspects + machine facts
  display/                   # typed monitor options + renderers (flake.lib.monitors)
  <concern>.nix              # a concern; declares its own aspect membership
  <concern>/*.nix            # a concern too large for one file
  **/_*                      # ignored by import-tree (`/_` anywhere in the path)
```

There is **no** `nixos/`, `home/`, `darwin/`, `pkgs/`, `overlays/`, or `profiles/`
directory. Creating one is a structural regression — say so instead of doing it.

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
   (monitors, hostname, sensitivity). Aspects are host-agnostic (Inv. 7), so these cannot
   come from the aspect — and a standalone Home Manager evaluation cannot read flake-parts
   `config`, so they cannot come by closure either. The host wiring is the only channel.

Forbidden: `specialArgs`, `extraSpecialArgs`, threading `self`/`inputs` into a nested
evaluation to reach a value, importing a module file by path to call a function out of it.

---

## 8. Hazards

- **Aspect elements are `types.raw`, not `deferredModule`.** `deferredModule` runs
  `setDefaultModuleLocation`, rewriting each element's `_file` — which is its module key,
  which changes collection order, which reorders list-valued options and moves store
  paths. Do not "improve" this without measuring.
- **`config` shadowing** inside `flake.modules.*` — see §7.
- **Eval-time vs config-time.** `lib.mkIf pkgs.stdenv.isLinux { ... pkgs.grim ... }` still
  *evaluates* `pkgs.grim` and will break a darwin build. Guard the reference, not just the
  config, or split the file.
- **Every module file is evaluated for every host.** A syntax error in a Hyprland-only
  file breaks the swift5 build. Expected, not a regression.
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

```bash
git worktree add ../dotfiles-prev <previous-commit>
old=$(nix build --no-link --print-out-paths "../dotfiles-prev#homeConfigurations.\"marcus@gpc\".activationPackage")
new=$(nix build --no-link --print-out-paths ".#homeConfigurations.\"marcus@gpc\".activationPackage")
nix store diff-closures "$old" "$new"          # must be EMPTY
diff -rq "$old/home-files" "$new/home-files"   # only intended files
git worktree remove ../dotfiles-prev
```

`swift5` takes neither Hyprland nor stylix, which makes it a free control: a swift5 path
that moves during Hyprland work means the change leaked.

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
| `pkgs/`, `overlays/`, `lib/` directories | Breaks feature closure; the derivation belongs with its config |
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

The repo does not yet satisfy §1. These are tracked, not licence to add more. See
`REFACTOR.md`.

1. **`extraSpecialArgs` is still in use.** ~10 files take `monitors`, `sensitivity`,
   `hostname`, `user`, or `homeStateVersion` as module arguments. Target: `_module.args`
   from the generator (§7.3).
2. **Aspects are named after host archetypes** — `core`, `dev`, `suckless`, `maximal`.
   `maximal` fuses three concerns: the Hyprland session, the heavy app set, and stylix.
3. **Paths still imply aspects.** 104 of 105 files have membership determined by their
   directory; only `modules/home/ccache.nix` declares an aspect its path does not.
   No file yet declares two aspects.
4. **The consequence:** `font` is split across three files (`core` declares
   `options.suckless.font`, `suckless` installs packages, `maximal` sets the size) and
   `mako` across two. The one-file form in §2 is the fix.
5. **`_` is used for grouping**, not only for non-modules — ~21 ordinary modules are
   hidden inside `_hyprland`, `_waybar`, `_thunderbird`, `_discord`, `_opencode`.
6. **`gaming` and `nvidia` are inline** in gpc's host file rather than being aspects.
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

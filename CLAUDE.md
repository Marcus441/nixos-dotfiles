# CLAUDE.md — Dendritic Nix configuration

This repository follows **the dendritic pattern**. Read §1 before editing anything. If a
change would violate an invariant, stop and say so rather than working around it — the
invariants are the whole value of this structure, and a single exception metastasises.

§12 lists where the repo does **not yet** satisfy its own invariants. Read it before
concluding that existing code is an example to copy.

| Host | Archetype | Session | Platform |
| --- | --- | --- | --- |
| `swift5` | laptop | dwl (Wayland, minimalist) | `x86_64-linux` |
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
4. **File paths carry no system-meaning.** A path never encodes a class, a host, an aspect,
   or a "type" — the module system does not read it. Paths are for the author's navigation;
   membership is declared in the file. Files move freely, and directories are navigation,
   not structure.
5. **No `specialArgs` / `extraSpecialArgs`.** Static values cross by closure over the
   flake-parts `config`; host-varying values arrive as `_module.args` injected by the host
   wiring. See §8.
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
# modules/filemanager/thunar.nix — one concern, two aspects, both classes, one file
{
  flake.modules.homeManager.core = [
    { options.fileManager.command = { /* the intent every session binds */ }; }
  ];

  flake.modules.homeManager.thunar = [ { fileManager.command = "thunar"; } ];
  flake.modules.nixos.thunar = [ { programs.thunar.enable = true; /* + the daemon */ } ];
}
```

A host is a short list of aspect names. Reading a host file should tell you what the
machine **is**.

### Read these before writing a new file

- `modules/filemanager/thunar.nix` — the sketch above, as an actual file: `core` declares
  `fileManager.command`, `thunar` sets it and the `nixos` half installs the daemon. One
  concern, two aspects, both classes. **This is the file to copy.**
- `modules/tmtheme.nix` — declares `desktop.syntaxTheme` in `core` and renders it from the
  palette; `bat.nix` and `filemanager/yazi.nix` read it. The provider/consumer split of §3
  in its smallest form.
- `modules/ccache.nix` — declares `dev` while sitting beside files that declare `core`.
  Nothing about its location says which. Invariant 4, demonstrated.
- `modules/dwl.nix`, `modules/hyprland.nix` — one concern spanning both `nixos` and
  `homeManager` in one file. Invariant 3, half-demonstrated.

**Nineteen files declare more than one aspect or more than one class.** Counted over
`modules/` excluding `/_`, by distinct `flake.modules.<class>.<aspect>` occurrences: 93 files
declare at least one, and 19 declare two or more — `bash`, `brightnessctl`, `dwl`, `dwl-bar`,
`git`, `gtk`, `hyprland`, `lock`, `logout`, `mako`, `neovim`, `net`, `nix`, `screenshot`,
`thunar`, `walker`, `waybar`, `wleave`, `xdg`. The other 74 contribute to exactly one.

So the single-aspect file is the majority but not the model. Copying an arbitrary
neighbour reproduces the majority; the nineteen above are where the second direction of the
merge is actually demonstrated. Check §12 before treating any file as an example.

Note what is *not* on that list any more: `font`, `launcher` and `clipboard` each declare one
aspect now. They lost their second membership when the thing on the other side went away —
`launcher` and `clipboard` when the setters moved into the sessions that own them, `font`
when stylix went. A file dropping to one aspect is not a regression; it means the concern
turned out to have one audience after all.

---

## 3. Naming aspects

An aspect is a **decision or a capability**, never a magnitude and never a host class.

- Good: `hyprland`, `dwl`, `gaming`, `nvidia`, `laptop`, `dev`.
- Bad: `maximal`, `minimal`, `heavy`, `extras` — magnitude names rot the first time you
  want one member without the others, and then the name lies.
- Bad: `desktop-machine`, `workstation` — that is a host archetype, not a concern. The
  archetype is the *list*, not an entry in it.

**An aspect earns its existence when some host says no.** If all hosts always take it, it
is `core`. Do not make every package an aspect: files already give you per-tool
granularity, and per-tool *selection* only turns each host into a duplicated manifest.

**A bad name is cheap to fix.** Renaming `suckless` to `dwl` in place left all six targets
byte-identical (the structural plan's Step 4 — that plan is in git history, and step
numbers below refer to it — measured against a predicted *changes* on all three
hosts). The name itself does not reach a store path — only its *position* in a host's
aspect list does (§5). So a name that has started to lie should be corrected, not kept for
fear of a rebuild.

The exception is a name that has leaked into generated text. The follow-up commit that
corrected prose naming the dead aspect *did* move swift5, because two of those strings are
rendered output rather than comments.

### Intent vs implementation

Two compositors share intent — what a key should *do* — but no code. Do **not** build one
`tiling-wm` aspect that branches internally, and do not force one aspect name to mean two
implementations — both files would declare the same attribute and merge into any host
taking it.

Instead: the portable part is an **option namespace**, the implementations are **separate
aspects**. `modules/launcher.nix` is the worked example — the intent in `core`, and each
implementation setting it from the file that owns the program:

```nix
# modules/launcher.nix — the intent, and nothing else
{
  flake.modules.homeManager.core = [
    ({config, lib, ...}: {
      options.launcher.argv = lib.mkOption { type = lib.types.listOf lib.types.str; };
      # plus `launcher.command`, readOnly, = lib.escapeShellArgs config.launcher.argv
    })
  ];
}

# modules/walker.nix — the provider names itself, in the session that binds the key
{ flake.modules.homeManager.hyprland = [ {launcher.argv = ["walker"];} ]; }

# modules/wmenu.nix
{
  flake.modules.homeManager.dwl = [
    ({config, pkgs, ...}: {
      launcher.argv = ["${pkgs.wmenu}/bin/wmenu-run"] ++ config.wmenu.flags;
    })
  ];
}
```

Hosts take `hyprland` **or** `dwl`, and both set the same option. §7 explains why the
shape is `argv` and not a string.

The setters sit in the provider's file, not in `launcher.nix`. That is the difference
between a file that owns an *intent* and one that owns a *program*: `launcher.nix` would
otherwise have to be edited every time a launcher changed, which is Inv. 3 inverted — one
file editing three features rather than three files editing one.

**The shared namespace is sometimes empty, and zero shared aspects is a valid outcome.**
This section used to sketch a `tiling` namespace carrying gaps and a mod key. It was never
built, and Step 4 recorded why: dwl's mod key is a `#define` in a C patch and dwl has no
gaps at all, so there was no shared *value* to lift. Step 4 likewise created no shared
session aspect — what the two sessions genuinely share is declared per-session inside the
one file that owns the concern, as `clipboard.nix`, `lock.nix` and `screenshot.nix` do.

Name an intent when two implementations actually diverge over a value. Naming one to
complete a set gives an option with no setter and no reader — see §7 on why
`notifications` is deliberately not an intent.

### A tool invoked by bare name must be installed by every aspect that invokes it

`modules/brightnessctl.nix` declares **both** `hyprland` and `laptop`, installing the same
package twice. That is correct, and the reasoning generalises:

- hypridle (`on-timeout = "brightnessctl -s set 30"`) and the Hyprland binds
  (`hl.dsp.exec_cmd("brightnessctl s 10%+")`) invoke it **by bare name**, so it has to be
  on `PATH` wherever that session runs.
- swift5 takes `laptop`; gpc and UM790pro take `hyprland` and *not* `laptop`. So
  `laptop`-only would have silently broken brightness control on both desktops — the
  concrete failure Step 7 caught.
- dwl needs neither entry: `modules/dwl.nix` interpolates the store path into the C
  `config.h` it compiles, so the binary carries its own reference.

**The rule.** If aspect A's config invokes a tool by bare name, every aspect that can
supply that config must install it. The resulting duplication is *not* an Invariant 3
failure: Invariant 3 is about one concern being spread across several files, and this is
one file declaring several memberships — the merge working as intended (§2).

Where the consumer can hold a path instead, interpolating the store path removes the
duplication and the `PATH` dependency at once. Prefer it when you have the choice; dwl
does, hypridle's settings string does not.

---

## 4. Layout and host wiring

Descriptive, not normative. Invariant 4 means the generator does not care where any file
lives — this is where things happen to sit, not a schema to pattern-match a new
`modules/wayland/` tree onto.

```
flake.nix                    # inputs + mkFlake + import-tree. Rarely touched.
statix.toml                  # lint config; the one disabled rule is argued in §13
modules/
  aspects.nix                # declares the flake.modules and aspectRequires options
  hosts/generator.nix        # the generator: the ONE permitted central wiring point
  hosts/record.nix           # the typed host record the generator consumes
  hosts/<hostname>.nix       # what this machine IS: archetype aspects + machine facts
  display/                   # monitor renderers (flake.lib.monitors)
  <concern>.nix              # a concern; declares its own aspect membership
  <intent>/                  # implementations of one intent, in different aspects
  <concern>/                 # assets a concern reads; import-tree collects only .nix
  **/_*                      # ignored by import-tree (`/_` anywhere in the path)
```

The `/_` filter is `hasInfix "/_"`, a literal substring test on the full path — which is
exactly the "anywhere in the path" rule above. Ordering is §5.

Directories that encode class — `nixos/`, `home/`, `darwin/` — are the one real
prohibition: the path would predict which `flake.modules.<class>` every file inside
declares, which is Invariant 4 inverted. `pkgs/`, `overlays/` and `profiles/` are also
prohibited, but for a different reason: they break feature closure by separating a
derivation from the config that consumes it (§6). Say so if a change would create one.

**Beyond those, directories are for human navigation, not a gated structure.** The
dendritic pattern's position is that paths convey meaning only to the author — Invariant 4
says paths carry no *system-meaning*, not that the tree must be flat. A directory is
worthwhile when it makes the tree easier to navigate; it becomes a problem only when its
name predicts the aspect or class of every file inside, because then the path is doing the
membership's job. A hypothetical `font/` would be fine, because `font` names no decision. A
`system/` directory holding every `nixos.core` file would not, because the path predicts
class and membership exactly — which is `nixos/` under another name.

**This is deliberately weaker than the rule it replaced,** which was conjunctive: safe when
the name would be a *bad aspect name* **and** the files span several aspects. The first
clause is dropped, and dropping it is the whole change. It ruled out exactly the directory
worth having — `filemanager/`, holding `thunar.nix` and `yazi.nix`, is named after the
`fileManager.command` intent those two files diverge over (§3), so `fileManager` is a
*good* name and the old rule forbade it. That gets the risk backwards. An intent-namespace
directory holding the implementations of that intent is the safest kind: the name is
precisely what the files have in common, and implementations of one intent are by
construction different aspects, so the path predicts nothing.

**When in doubt, ask whether the directory name is doing the aspect system's job.** If
every file inside declares the same aspect, the directory is redundant with the aspect name
and the files should be flat. If the files span several aspects, the directory is pure
navigation and is fine.

**`core` does not count toward "several aspects".** Every host takes `core`, so a `core`
block is not a discriminating membership — if an `options.*` declaration in `core` made a
directory multi-aspect, almost anything would qualify, `hyprland/` included. Count only
aspects some host declines. `bar/` is the worked case, because it was both things in turn:
holding only the three `waybar*` files it was `waybar` plus a `core` option declaration, so
it was the flat case and was left flat. `dwl-bar.nix` landing beside them made it two
declining aspects and the directory legal — the same files, the same name, a different
answer. Directories in the tree today: `filemanager/` and `bar/` span declining aspects;
`discord/` and `opencode/` hold assets rather than modules; `display/` holds one file;
`hosts/` is the wiring.

Host files declare archetype and machine facts only:

```nix
{
  hosts.gpc = {
    hostname = "gpc";
    system = "x86_64-linux";
    stateVersion = "25.11";
    aspects = ["core" "hyprland" "gaming" "nvidia"];

    hardware = ../../hosts/gpc/hardware-configuration.nix;
    monitors = [ { name = "DisplayPort-1"; width = 2560; height = 1440; refresh = 144; } ];
  };
}
```

Aspect order in that list is load-bearing — see §5.

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

## 5. Ordering and store paths

Order is the one thing about this structure that reaches a derivation hash. Read this
before any change that moves, renames or regroups files, or that touches a host's aspect
list.

**Import order is a depth-first walk, per-directory alphabetical.** From import-tree's
source: `builtins.attrNames` returns names sorted, and directories recurse inline at their
own name's position. Component-wise path order — not a global basename sort.

**Aspect order in a host's list is load-bearing.** It determines module merge order, which
determines `buildEnv` order, which reaches derivation hashes. Reordering a host's `aspects`
is a real change, not a cosmetic one. When splitting one aspect into two, put the new names
where the old one sat so the split is a partition rather than a reordering.

**What reaches store paths is narrower than the walk.** A host's `home.packages` is the
concatenation over its *aspect list*, in host-list order; within each aspect, contributions
land in discovery order. So only the **relative order of files contributing to the same
aspect** matters. Interleaving files of different aspects is invisible — the aspect list
already separated them.

That model predicts both things Step 0 measured: relocating ~70 files was byte-identical,
because a total flatten preserves within-aspect relative order, while renaming
`monitors.nix` moved its package from position 1 to 11, because it changed that file's rank
among its own aspect's siblings. It is also why a *partial* move is not automatically free.

**Treat it as a working model, not a mechanism.** Three measurements bound it:

- A controlled probe produced a definition order the model does not predict, so discovery
  order is not strictly positional.
- A *position-preserving* move is free even though it changes `_file`:
  `modules/monitors.nix` → `modules/monitors/monitors.nix` left swift5 byte-identical
  (re-measured after §9's `deferredModule` change).
- Within-aspect rank only reaches the output when two files contribute to the same
  list-valued option. Step 6 surfaced 21 files out of `_hyprland/`, changing both their
  rank and the tree's hand-written import order, and all six targets stayed identical —
  a sound prediction of *changes* that was still wrong.

**Measure with the recipe in §10; do not predict.**

---

## 6. Task recipes

### Add a feature

1. Name the aspect after the decision or capability (§3).
2. Create `modules/<concern>.nix`.
3. Declare membership for every class and aspect it touches. Omitting `darwin` is normal
   and correct for Linux-only features.
4. Add the aspect name to the relevant hosts.
5. Verify (§10).

### Extend a feature

Add a **new file** targeting the same `flake.modules.<class>.<aspect>`. Do not grow one
file past readability, and do not add an enable flag to gate new behaviour — split into
two files and let hosts differ by which aspect they take.

### Add a host

Add `modules/hosts/<hostname>.nix`. The generator produces both output sets from the
attribute name, so they cannot drift; it rejects a `hostname` that disagrees with its
attribute, aspect names that resolve in no class, and an aspect list that leaves an
`aspectRequires` entry unmet.

**When an aspect depends on another aspect, say so where the dependency is created.**
`waybar` reads Hyprland's IPC — `hyprland/window`, `hyprland/workspaces`, `hyprctl` — so a
host taking it without `hyprland` would get a bar with three dead modules. `waybar.nix`
declares `aspectRequires.waybar = ["hyprland"];` beside its membership, and the generator
rejects a host that leaves it unmet. Declaring it in the file that creates the dependency is
what keeps it from drifting — a central table would not know when a file stops reading.

Seven files once declared `aspectRequires.<aspect> = ["stylix"];` because they read
`config.lib.stylix.colors`. None do: the palette moved to `core`, and a value every host has
cannot create a cross-aspect dependency. That is the shape to aim for — a requirement is a
last resort, and moving the thing being read into `core` removes it outright.

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

## 7. Class placement — and the Mac

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

Cross-platform intents are named so the Mac is cheap later: `launcher`, `screenshot`,
`clipboard` and `lock` are option namespaces in `core`, set by `hyprland` and `dwl` and
read by their binds (§3). A darwin session implements them by setting the same options —
that is the whole point of the indirection.

`notifications` is deliberately **not** one: mako already serves both sessions from a
single file and nothing invokes it by command, so the option would have no setter and no
reader. Name an intent when two implementations actually diverge, not to complete a set.

Their shapes are set by their consumers, not by taste. `launcher.argv` is a list because
dwl's binds are a C argv array while Hyprland's are shell strings, with `launcher.command`
as its read-only shell rendering; the rest are shell strings. A consumer that embeds one
somewhere with its own quoting rules re-escapes it — `modules/dwl.nix` does this for the C
string literals in its generated `config.h`.

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

## 8. Sharing values

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

## 9. Hazards

- **Aspect elements are `types.deferredModule`.** They were `types.raw` until Step 1 of
  the previous refactor plan, on the grounds that `deferredModule` had been measured to move store
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

  Provenance across the 98 files `import-tree` loads, which is the whole reason for it.

  The risk this was tested for is elements *vanishing* — a multi-element aspect list
  declared in one file could in principle lose members. `modules/walker.nix` is the case
  that remains: it pairs a flake input's module with a local one, and both elements
  survived. (`modules/stylix.nix` was the other, and is gone.) Note that
  `builtins.length config.flake.modules.…` does **not** detect this; the byte-identity
  block in §10 does. Re-run all three parts of it if you change the element type again.
- **`config` shadowing** inside `flake.modules.*` — see §8.
- **ANSI is not free just because foot sets it from the palette.** A program that names
  terminal colours (`blue`, `gray`) inherits the palette correctly, because it asserts
  nothing about which slot that is. A program asking for *the base16 theme* asserts that
  ANSI 9 holds base09 — and `foot.nix` puts base12 there, because that is what base24 calls
  bright red. bat rendered numbers in the wrong colour for exactly this reason until it was
  moved onto `desktop.syntaxTheme`. Check which kind you have before reaching for ANSI.
- **A colour correct in one role is wrong the moment something reads it in another.** yazi's
  status bar is Lua: `status.lua` draws each powerline separator by taking the *next*
  segment's background and using it as a foreground — `:fg(style.alt:bg())`. Under
  `bg = "reset"` that resolves to the terminal's default *foreground*, base05, putting a
  bright bar mid-status-line; base00 makes the separator vanish while the segment still
  reads as transparent. `progress_normal` keeps `reset` because `progress.lua` passes it to
  `gauge_style` and nothing transposes it. **`reset` is a value that only survives being
  drawn.** Check whether anything reads a colour back before choosing one.
- **Every *file* is evaluated once**, at the flake-parts level — so a syntax or eval error
  anywhere breaks every host. But an **aspect's contents are only evaluated by hosts that
  take it**: a `throw` inside `apps` does not break swift5. Verified, not assumed.
- **Eval-time vs config-time.** Within an aspect a host *does* take,
  `lib.mkIf pkgs.stdenv.isLinux { ... pkgs.grim ... }` still evaluates `pkgs.grim`. Guard
  the reference, not just the config, or split the file. This does **not** mean a
  Linux-only reference in an aspect `mbp` never takes needs guarding — it doesn't.
- **An interpolation at column 0 reindents a whole generated file.** `''` strips the least
  indentation of any line, and a line beginning `${...}` has none — so splicing a block in
  at the left margin sets the strip depth to zero and every other line keeps its source
  indentation. `dwl.nix` renders `config.h` from five such blocks and keeps all five at the
  literal's own indent, which puts them at column 0 of the *output*; the one spliced inside
  an array carries its two spaces in the string. The failure is silent — a valid file that
  is wrong throughout, not an error.
- **`git add -A` before every `nix` command.** Flakes see only tracked files; skipping
  this gives "path does not exist" for files visibly on disk.
- **Never switch.** No `nixos-rebuild switch`, no `nh os switch`, no `home-manager switch`.
  Build only — the human switches.
- **Build on `UM790pro`.** Building the Hyprland closures on `swift5` drags the whole
  Hyprland chain onto the laptop.

---

## 10. Verification

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

`swift5` takes neither Hyprland nor `apps`, so it is a useful control *for work on those* —
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

## 11. Anti-patterns

| Anti-pattern | Why |
| --- | --- |
| `nixos/`, `home/`, `darwin/` directories | Paths encode class, not concern (Inv. 4) |
| `pkgs/`, `overlays/` directories | Breaks feature closure; the derivation belongs with its config |
| A `lib/` directory of helpers | A helper library is not a flake-parts module (Inv. 1). Expose the value as an option (§8) |
| `imports = [ ./foo.nix ]` inside `modules/` | `import-tree` already loaded it (Inv. 6) |
| `specialArgs = { inherit self inputs; }` | Closure or `_module.args` (Inv. 5, §8) |
| `_` to group related files | `_` is for non-modules only (§4) |
| An aspect named `maximal` / `minimal` | Magnitude, not a decision (§3) |
| `mkEnableOption` per aspect | Hosts compose by taking aspects, not by enabling |
| One aspect that branches between dwl and Hyprland | Option namespace + variant aspects (§3) |
| Aspect reading `config.networking.hostName` | Aspects are host-agnostic (Inv. 7) |
| Editing three files to add one feature | The concern is wrongly decomposed (Inv. 3) — but see §3: one file installing the same tool into several aspects is not this |

Four rows are about paths: the first three — class-encoding, closure-breaking and
helper-library directories — plus `_` as a grouping mechanism (§4: `/_` is for non-modules
only). The rest of the table is module-system mistakes, not directory structure.
**Directories for navigation are otherwise permitted** (§4); the question is only whether
the directory name is doing the aspect system's job. A `font/` is navigation, and so is
`filemanager/`, which holds two implementations of one intent. `hyprland/` is not: it is
redundant with the `hyprland` aspect name, and all seven files in it declare that one
aspect — `hyprland.nix` adds a second *class*, which is not a second aspect.

---

## 12. Known divergences

**This is a ratchet, not a ledger:** if a task touches a file listed here, migrate that
file in the same change, or state plainly why not. Nothing below is grandfathered, and the
count is supposed to fall.

Two finished plans closed items 1–6 — the structural one that made aspects replace the
directory tree, and the one that retired stylix in favour of the palette. Both are in git
history with their per-step measurements (`git log --oneline --all -- REFACTOR.md`). So the
structural invariants in §1 now hold and the exemplars in §2 are real files rather than
sketches. What is left is a platform gap, not a pattern violation.

**Item numbers are stable identities, not positions.** A closed item is deleted and the
survivors keep their numbers, so this list does not necessarily start at 1 and its numbers
are safe to cite.

7. **No darwin.** `systems = ["x86_64-linux"]`; `mbp` is planned, not present.

---

## 13. Working style

- **Structural changes go through the `dendritic-reviewer` subagent — before the commit,
  not after.** Structural means: moving, renaming or regrouping files; adding, splitting,
  renaming or retiring an aspect; changing a host's aspect list; editing the generator or
  `aspects.nix`. An ordinary edit inside one existing file does not need it. The agent
  reads and reports — *violation*, *risk* or *preference*, each named against §1 — and
  does not edit; this session decides and acts on what it finds.
- **Small, single-concern commits.** Rationale goes in the commit message, not in comments.
- **Terse comments.** Explain *why*, never *what*.
- **Prefer adding a file to editing one**, especially when extending an aspect.
- **No unrequested changes.** No package bumps, no deprecation fixes, no reformatting
  files the current task does not touch.
- **The five ex-`common-packages` tools stay in `nixos`.** `common-packages.nix` was
  dissolved (`317abf5`) and its members went to the concerns that own them — `home-manager`
  to `home-manager.nix`, `iw` and `wget` to `net.nix`, `gh` to `git.nix`, `htop` to its own
  file. All five stayed in `environment.systemPackages` rather than moving to
  `home.packages`. That is against §7's default-to-`homeManager` rule and was chosen: the
  move would change which profile they install into, which is a behavioural change wearing
  a refactor's clothes. **This is an accepted choice, not a divergence** — it is deliberately
  absent from §12, so do not "fix" it as ratchet work.
- **`statix.toml` disables `repeated_keys`, and it stays disabled.** The rule fires on a
  file that assigns `flake.modules.<class>.<aspect>` more than once and proposes collapsing
  it to `flake = { modules.homeManager.core = …; }`. That is the wrong direction here: it
  buries the aspect name a level deeper and makes parallel declarations read as one thing
  with parts. The eight files it flags are `bash`, `screenshot`, `thunar` and `wmenu` —
  §2 exemplars, every one — plus `gtk` (which it flags for a repeated `gtk4` key, not for
  this pattern) and the three `hosts/*/hardware-configuration.nix`, which §4 says never to
  edit. It is silent on all 74 single-aspect files, so its signal is inverted: it flags the
  best files and the untouchable ones. Measured twice — applying it to `bash.nix` produced exactly that nesting and dropped
  the file's only rationale comment, and splitting mako's battery rule into a third aspect
  *raised* the count. **An accepted choice, not a divergence**, deliberately absent from §12.
- **Do not introduce a framework** (`den`, `snowfall`, `flake-file`, `easy-hosts`) without
  being asked. This repo depends on `flake-parts` and `import-tree` only.
- **Deliberately deferred — do not propose these unasked.** Quickshell (waybar and walker
  stay); a dwl host taking `waybar` or `walker`, which has four blockers recorded in the
  structural plan in git history. Darwin is the same kind of decision but is tracked as §12
  item 7, because it is a gap rather than a preference. dwl's conditional bar patch has left
  this list: it was asked for and is built, as the `dwl-bar` aspect.
- **Waybar's opt-in shape is finished; do not re-propose it.** `waybar` and `wleave` are
  already separate aspects that only `gpc` and `UM790pro` take, `aspectRequires.waybar =
  ["hyprland"]` rejects a dwl host outright rather than handing it three dead modules, and
  `waybar.nix` already embeds wleave as `custom/power`, gated on `powerMenu.command` so the
  button is omitted rather than rendered dead. Nothing about this needs building.
- **dwl's bar is `dwl-bar`, and its shape is settled.** `dwl.nix` declares `dwl.bar`,
  `dwl.patches` and `dwl.buildInputs` in `homeManager.dwl` and `dwl.statusCommand` in
  `nixos.dwl`; `bar/dwl-bar.nix` sets all four and declares `aspectRequires.dwl-bar =
  ["dwl"]`. The boolean is not redundant with `patches != []` — an unrelated patch appended
  by some later file would not imply a bar — and it is not §11's "one aspect that branches
  internally", because the branch is between two builds of one compositor and the decision
  arrives from a sibling aspect the host lists. `statusCommand` stays in `nixos.dwl` rather
  than `core` for §7's `notifications` reason: one setter, one reader, both dwl-only.
  **The failure mode is silent by construction** — a `dwl` host without `dwl-bar` builds a
  working bar-less dwl, which is the feature, so nothing will alarm if the aspect is ever
  dropped by accident. `nix eval '.#homeConfigurations."marcus@swift5".config.dwl.bar'`
  is the cheap check.
- **Finished plans go to git history, and nothing in the tree cites a plan file.** Cite a
  §-number here or a commit hash instead. `REFACTOR.md` was replaced wholesale three times
  and each replacement silently broke every pointer at it — by the time it was retired, all
  three in-tree citations named sections that no longer existed. Section numbers are stable
  by §12's rule; a filename is not.
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

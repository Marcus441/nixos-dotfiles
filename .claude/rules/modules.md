---
paths: "modules/**/*.nix"
---

# Writing a file under `modules/`

The invariants are in `AGENTS.md` §1 and are not restated here. This is the
mechanics: how the merge works, how values cross between files, and what fails
silently.

## The merge runs in both directions

NixOS / darwin / home-manager modules are not imported from paths — they are
**option values** under `flake.modules.<class>.<aspect>`, typed
`deferredModule`, and those attrsets **merge**.

- **Many files → one aspect.** Growing a feature means *adding a file*, never
  editing a list.
- **One file → many aspects.** A single concern can contribute to several
  aspects and both classes at once. This is the direction that gets forgotten.

Two independent axes: the unit of **concern** is the *file*; the unit of
**applicability** is the *aspect*. Neither contains the other.

`modules/aspects.nix` declares both options with a `deferredModule` type, which
is what the dendritic README's "Not declaring options" anti-pattern asks for.

## Read before writing a new file

- `modules/filemanager/thunar.nix` — one concern, two aspects, both classes.
  **This is the file to copy.**
- `modules/theme/tmtheme.nix` — provider/consumer split: declares
  `desktop.syntaxTheme` in `core`, read by `bat.nix` and `yazi-style.nix`.
- `modules/ccache.nix` — declares `dev` beside files declaring `core`. Nothing
  about its location says which. Inv. 4 demonstrated.
- `modules/dwl/dwl.nix`, `modules/hyprland.nix` — one concern spanning both classes.

The single-aspect file is the majority but not the model — copying an arbitrary
neighbour reproduces the majority and misses the second direction of the merge.
`docs/inventory.md` has the current multi-membership count. Check `AGENTS.md`
§8 before treating any file as an example.

## Sharing values between files

In order of preference:

1. **`let` binding** — when only that file needs it.
2. **A flake-parts option** — when other files need it. Capture the flake-parts
   `config` in an outer `let`; inside `flake.modules.*`, `config` is the *guest*
   config, not flake-parts'. Getting this wrong produces infinite recursion,
   not a clear error.
3. **`_module.args`, injected by the host wiring** — for values that vary per
   host (monitors, hostname). An aspect is a single value shared by every host
   that takes it, so there is nothing for a closure to specialise on (Inv. 7).

**`_module.args` cannot compute `imports`** — imports resolve before config, so
using an injected arg to decide imports is infinite recursion. If an import
needs a host fact, that fact is a *decision*, and decisions belong in the host's
aspect list.

**Forbidden:** `specialArgs`, `extraSpecialArgs`, threading `self`/`inputs` into
a nested evaluation, importing a module file by path to call a function.

## Provider/consumer split

When two implementations share an intent but no code, the portable part is an
**option namespace** in `core` and the implementations are **separate aspects**.
The setter sits in the provider's file, not the namespace's — otherwise the
namespace file would be edited every time a provider changed (Inv. 3 inverted).

`launcher.nix` declares `launcher.argv` in `core`; `walker.nix` sets it from
`hyprland`, `wmenu.nix` from `dwl`.

**A shared namespace is sometimes empty.** `clipboard`, `lock` and `screenshot`
share intent across sessions but were never abstracted — the shared config is
declared per-session in the one file that owns the concern. Zero shared aspects
is a valid outcome. Full table: `docs/conventions/intents.md`.

## A tool invoked by bare name must be installed by every aspect that invokes it

`brightnessctl.nix` declares **both** `hyprland` and `laptop`, installing the
same package twice. That is correct — one file, several memberships — not an
Inv. 3 failure. Where the consumer can hold a store path instead (`dwl/dwl.nix`
interpolates it into C code), prefer that.

## Directories

**Test:** a directory is named for a feature and exists because that feature
outgrew one file. The files inside may span declining aspects (`lock/`,
`launcher/`) or all declare the same one (`hyprland/`, `gaming/`) — both are
navigation, and neither carries system-meaning. Prohibited: a directory named
for a class, host, or magnitude; a grab-bag no single feature names; a
directory holding one module file (flatten it).

`/_` is for non-modules only: values consumed by `import`, derivations consumed
by `callPackage`, dormant code. **It is not a grouping mechanism.**
`import-tree` skips any path matching `hasInfix "/_"`. A helper may live inside
its feature's directory (`wallpaper/_wallpapers.nix`, `launcher/_walker/`) —
`hasInfix "/_"` still skips it.

## Things that fail silently rather than loudly

Each of these was measured. Rationale in `docs/decisions/`.

- **`flake.modules` is an open attrset.** `flake.modules.homemanager.core`
  type-checks, is read by nobody, and drops its modules in silence. The explicit
  `classes` list in `hosts/generator.nix` is what catches it.
- **An option declared outside its own `mkIf` still resolves.** `yazi.nix`'s
  `finalPackage` sits outside `mkIf cfg.enable`, so a host taking `yazi` without
  `apps` would get an unconfigured `pkgs.yazi` rather than an error.
  `aspectRequires` turns that into a rejection naming the aspect.
- **A second `ExecStart=` on a non-oneshot systemd service refuses to load.**
  NixOS merges `systemd.user.services.<name>` as a drop-in *over* the packaged
  unit, so an override adding install wiring must not restate `ExecStart`.
- **`throwIf` order is fold order.** Checks built by folding a list wrap the
  accumulator, so the **last** entry is outermost and fires **first**.
- **A strict argument pattern is a wiring check.** `makeSystem` matches
  `monitors` and `input` without using them, so a newly declared host option
  must be wired there rather than silently ignored.
- **Reading a merged option back can win the wrong value.** Bind the value
  directly where a `mkForce` elsewhere would redirect it — `yazi.nix` and
  `fileManager.command`.
- **Eval-time vs config-time.** `lib.mkIf pkgs.stdenv.isLinux { … pkgs.grim … }`
  still evaluates `pkgs.grim`. Exclude by attribute (`lib.optionalAttrs`), not
  by value (`lib.mkIf`).
- **`config` shadowing** inside `flake.modules.*` — see *Sharing values* above.
- **An interpolation at column 0 reindents a whole generated file.** `''` strips
  the least indentation; a line beginning `${...}` has none.
- **Aspect elements are `types.deferredModule`.** Switching from `types.raw`
  left all six targets byte-identical; the change buys provenance. Re-run the
  full diff-closures check if you change the element type again.

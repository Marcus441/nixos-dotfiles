---
paths: "modules/**/*.nix"
---

# Writing a file under `modules/`

## The invariants, in full

1. **Every `.nix` file under `modules/` is a flake-parts module.** Not a NixOS
   module, not a home-manager module, not a package expression, not a helper
   library. One interpretation, always.
2. **`flake.nix` is a manifest.** Inputs plus `mkFlake` plus `import-tree`. No
   configuration logic. Edited only to add an input.
3. **One file = one concern, across every class and every aspect it touches.**
   A single file may declare multiple aspects and multiple classes — that is
   the merge working as intended. The violation is one concern spread across
   several files.
4. **File paths name the feature but carry no system-meaning.** A path never
   encodes a class, a host, an aspect, or a "type" — the module system does not
   read it. Files move freely; directories are navigation, not structure.
5. **No `specialArgs` / `extraSpecialArgs`.** Static values cross by closure
   over the flake-parts `config`; host-varying values arrive as `_module.args`
   injected by the host wiring. See `sharing-values.md`.
6. **No manual import lists** except the host wiring. `import-tree` discovers
   everything else.
7. **Aspects are host-agnostic and platform-agnostic.** Machine facts —
   hostname, `hostPlatform`, `stateVersion`, disk layout, monitor geometry —
   live at the host.

## The merge runs in both directions

flake-parts is the *top-level configuration*. Every file participates in that
one evaluation. NixOS / darwin / home-manager modules are not imported from
paths — they are stored as **option values** under
`flake.modules.<class>.<aspect>`, typed as `deferredModule`, and those
attribute sets **merge**.

- **Many files → one aspect.** Growing a feature means *adding a file*, never
  editing a list.
- **One file → many aspects.** A single concern can contribute to different
  aspects and several classes at once. This is the direction that gets
  forgotten.

Two independent axes: the unit of **concern** is the *file*; the unit of
**applicability** is the *aspect*. Neither contains the other.

> **Note on `deferredModule`:** The dendritic README warns against using *only*
> flake-parts' built-in `flake.modules` without declaring typed options (the
> "Not declaring options" anti-pattern). `modules/aspects.nix` declares the
> `flake.modules` and `aspectRequires` options with `deferredModule` type,
> which is the recommended approach.

## Read before writing a new file

- `modules/filemanager/thunar.nix` — one concern, two aspects, both classes.
  **This is the file to copy.**
- `modules/theme/tmtheme.nix` — provider/consumer split: declares `desktop.syntaxTheme`
  in `core`, read by `bat.nix` and `yazi.nix`.
- `modules/ccache.nix` — declares `dev` beside files declaring `core`. Nothing
  about its location says which. Inv. 4 demonstrated.
- `modules/dwl.nix`, `modules/hyprland.nix` — one concern spanning both `nixos`
  and `homeManager` in one file.

**25 of the 104 files that declare an aspect declare more than one** aspect or
class. The single-aspect file is the majority but not the model — copying an
arbitrary neighbour reproduces the majority and misses the second direction of
the merge. Check CLAUDE.md's "Known divergences" before treating any file as an
example.

> **Recount when a file gains or loses a membership** — these two numbers go
> stale silently, and nothing in the build checks them. Run
> `scripts/recount-aspects.sh` and update the "25 of 104" figure above if it has
> changed.

## A tool invoked by bare name must be installed by every aspect that invokes it

`brightnessctl.nix` declares **both** `hyprland` and `laptop`, installing the
same package twice. That is correct: hypridle and Hyprland binds invoke it by
bare name, so it must be on `PATH` wherever those sessions run. This is not an
Inv. 3 failure — it is one file declaring several memberships (the merge
working as intended). Where the consumer can hold a store path instead
(`dwl.nix` interpolates it into C code), prefer that.

## Directories

**Test:** if every file inside declares the same declining aspect, the
directory is redundant and the files should be flat. If the files span
declining aspects, the directory is pure navigation and is fine. **`core` does
not count toward "several aspects"** — every host takes `core`.

`filemanager/` (two implementations of one intent, different aspects) is fine.
`hyprland/` holding only `hyprland` files would not be — the directory is
redundant with the aspect name.

`/_` is for non-modules only: values consumed by `import`, derivations consumed
by `callPackage`, dormant code. **It is not a grouping mechanism.**
`import-tree` skips any path matching `hasInfix "/_"`.

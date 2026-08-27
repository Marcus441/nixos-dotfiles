# NixOS Config

My personal NixOS configuration, featuring a Kanagawa Dragon themed desktop.

It follows **the dendritic pattern**: every `.nix` file under `modules/` is a
flake-parts module, and NixOS / home-manager modules are stored as option values
under `flake.modules.<class>.<aspect>` rather than imported from paths. There are
no profile directories and no per-class trees — a host is a short list of aspect
names, and adding a feature means adding one file.

`AGENTS.md` is the authority on the pattern and its invariants. This file only
covers getting a machine running. [`docs/`](docs/) holds the reasoning:
[`conventions/`](docs/conventions) for the patterns that recur across files,
[`decisions/`](docs/decisions) for why an individual file made the call it made.

## Inspiration and Attribution

The pattern is not mine, and neither is most of the reasoning behind it. What
each source actually contributed:

**[mightyiam/dendritic](https://github.com/mightyiam/dendritic)** — the
canonical specification, by **mightyiam** (Rodrigo Morales). Invariants 1–4 in
`AGENTS.md` are its rules restated: one file per feature across every
configuration that feature touches, lower-level modules held as
`deferredModule` *option values* rather than imported from paths, and file paths
that name a feature without encoding a class or a host. Its own caveat — the
pattern is "not a religion, law or a mandate" — is why `AGENTS.md` §8 tracks
where this repo diverges instead of pretending it doesn't.

**[The Dendritic Pattern — NixOS
Discourse](https://discourse.nixos.org/t/the-dendritic-pattern/61271)** —
mightyiam's announcement thread. The point taken from it is that every file is a
*flake-parts* module, not merely a NixOS one; that is what lets a single file
declare both a `nixos` and a `homeManager` membership, which is the shape of
nearly every file under `modules/`. vic's `rdesk.nix` in that thread is the
example those files follow. The thread's recurring complaint — that lazy
evaluation makes this read as black magic — is why `AGENTS.md` opens with a
mental model rather than a file tour.

**[Doc-Steve/dendritic-design-with-flake-parts](https://github.com/Doc-Steve/dendritic-design-with-flake-parts)**
— a guide by **Doc-Steve** that extends the pattern with a catalog of reusable
*Aspect* shapes. This is where the vocabulary of aspects comes from, and its
Collector and Constants shapes are what `windowTags` and the `desktop.colors`
palette turned into here: many files writing one value, one file reading it.

**[import-tree](https://github.com/vic/import-tree)** — the auto-import library,
by **vic** (pinned in `flake.nix` from its `denful/import-tree` location).
`flake.nix` is a manifest only because this exists. Its rule that paths
containing `/_` are skipped — `hasInfix "/_"` against the full path — is the
only way anything under `modules/` escapes auto-discovery, which is what
`modules/_pkgs` and `modules/launcher/_walker` both depend on.

**[Search for best dotfiles structure: Dendritic
edition](https://discourse.nixos.org/t/search-for-best-dotfiles-structure-dendritic-edition/75134)**
— the counterweight thread, where people report living with the pattern:
complexity outgrowing the configuration it serves, fuzzy-finding by filename
getting worse, and NixOS and home-manager configurations becoming hard to
decouple. That last one shaped two choices here — Home Manager stays
**standalone**, and `verify.sh` builds all six targets rather than trusting
`nixos-rebuild` to cover them. The alternatives raised there (`flake-aspects`,
`den`, `flake-fhs`, `unify`) are deliberately not used; this repo stays on
flake-parts and import-tree.

**[nixos-config-reborn](https://github.com/Andrey0189/nixos-config-reborn)** by
**@Andrey0189** — where this configuration began, and how I learned most of what
it does. Very little of that structure survived the dendritic refactor, but the
code is descended from it, so this repository remains licensed under the **GNU
General Public License v3.0 (GPL-3.0)** in accordance with the original. A copy
is in `LICENSE`.

## Hosts and aspects

Generated, not written down: **[`docs/inventory.md`](docs/inventory.md)** — every
host's aspect list in order, every aspect with the classes and file count behind
it, and the aspect dependencies. Regenerate with `./scripts/inventory.sh`.

An aspect is a decision or a capability that some host declines. It is not a
magnitude and not a host archetype — the archetype is the *list*, not an entry
in it. Six build targets: three `nixosConfigurations.<host>` and three
`homeConfigurations."marcus@<host>"`. Home Manager is **standalone**, activated
separately rather than as a NixOS module.

## Installing

1. **Install NixOS** using the official
   [installation guide](https://nixos.org/manual/nixos/stable/#sec-installation),
   then clone this repository:

   ```bash
   git clone https://github.com/Marcus441/nixos-dotfiles.git ~/.dotfiles/flake
   cd ~/.dotfiles/flake
   git config core.hooksPath .githooks
   ```

   The location is load-bearing: `modules/nh.nix` points `programs.nh.flake` at
   `/home/<user>/.dotfiles/flake`, so `nh os switch` finds nothing if the tree
   lives anywhere else.

   The hooks in `.githooks/` are tracked, but `core.hooksPath` is per-clone
   local config: it is not cloned, so the line above is run once per checkout
   or the hooks sit there inert.

2. **Drop in the hardware config** — the one machine-generated file, never
   edited by hand:

   ```bash
   mkdir -p hosts/<hostname>
   cp /etc/nixos/hardware-configuration.nix hosts/<hostname>/
   ```

3. **Write `modules/hosts/<hostname>.nix`** — the aspect list plus this
   machine's facts. Copy an existing host file; the record is matched strictly,
   so a missing field is an evaluation error rather than a silently absent
   module.

4. **Build, then activate.** Flakes only see tracked files, so stage first:

   ```bash
   git add -A
   ./scripts/verify.sh build     # every target the flake produces
   ```

   The target list is read out of the flake rather than written down in the
   script, so the host added in step 3 is built here instead of being silently
   skipped in favour of the machines that already existed.

   Then activate, in this order:

   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   home-manager switch --flake .#<user>@<hostname>
   ```

   The order is load-bearing on a machine that has never run this config: the
   `home-manager` CLI arrives with the NixOS switch (`modules/home-manager.nix`),
   so going home-first needs `nix run nixpkgs#home-manager --` instead. The
   extra substituters are part of the config being installed too, so the first
   build cannot use them and compiles locally whatever `nvf.cachix.org` would
   have served; passing them by hand only works as root, because
   `trusted-users = root` makes `--option extra-substituters` a no-op for
   anyone else.

   After that it is `nh os` / `nh home` as the daily driver.

## Verifying

```bash
./scripts/verify.sh build       # build every target the flake produces
./scripts/verify.sh [<ref>]     # compare every target against a ref (default HEAD~1)
./scripts/docs-check.sh         # decision register: pointers, orphans, budgets
./scripts/inventory.sh          # regenerate docs/inventory.md
nix flake check                 # cheap eval sweep
```

`verify.sh` compares output store paths, which is a proof of equivalence rather
than an eyeball judgement — `./scripts/verify.sh HEAD` on a clean tree must
report 6 PASS.

## Working on it

**[`AGENTS.md`](AGENTS.md)** is the authority on the pattern, its invariants and
its hazards; `CLAUDE.md` is a one-line import of it, so Claude Code, opencode
and codex all read the same file.

## Contributions

You can make a pr if you really want, but I'll probably just ignore it because
these are my personal configs.

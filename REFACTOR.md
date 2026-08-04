# Refactor Plan: Shell Unification + Dendritic Migration

Three phases. Phase 1 lands on `main`. Phase 2 happens on an orphan branch that
later becomes `main`. Phase 3 runs on the new `main` after the rename, once the
neutral-diff constraint is lifted. Every numbered step ends in a commit that
builds.

**Quickshell is explicitly out of scope.** Waybar and walker stay. Do not touch
them.

---

## Ground rules (both phases)

1. **Every step ends buildable.** Run `./scripts/verify.sh build` before
   committing. If it fails, fix or revert — never commit a broken tree and
   "fix it in the next one."
2. **`git add -A` before every `nix` command.** Flakes only see tracked files.
   Untracked files produce confusing "path does not exist" errors for files
   that are visibly present.
3. **Never run `nix flake update`.** Adding a *new* input and running
   `nix flake lock` is fine (it only fills in missing nodes). Updating existing
   pins destroys the Phase 2 verification baseline.
4. **Build only, never switch.** No `nixos-rebuild switch`, no `nh os switch`,
   no `home-manager switch`. The human does all switching.
5. **No opportunistic improvements.** No package bumps, no "deprecated option"
   fixes, no reformatting untouched files. Especially in Phase 2, where an
   unrequested change breaks the only safety net.

### Hosts

| host       | profile  | dev   | notes                   |
|------------|----------|-------|-------------------------|
| `swift5`   | suckless | true  | laptop, dwl             |
| `gpc`      | maximal  | false | hyprland                |
| `UM790pro` | maximal  | true  | hyprland, primary machine |

User is `marcus`. Six build targets total: three
`nixosConfigurations.<host>.config.system.build.toplevel` and three
`homeConfigurations."marcus@<host>".activationPackage`.

Run all builds on `UM790pro`. Building the maximal closures on `swift5` drags
Hyprland and the whole stylix chain onto the laptop.

---

# Phase 1 — bash + foot as the shared stack

**Runs on `main`, before the Dendritic work.**

Rationale: right now `fish` + `starship` + `ghostty` live in
`home-manager/profiles/maximal/` and `bash` + `foot` live in
`home-manager/profiles/suckless/`. Doing this after the refactor would mean
carefully translating code you are about to delete.

**This phase deliberately changes behaviour.** Unlike Phase 2, the store-path
diff will *not* be empty. Success means "builds, and the diff contains only the
expected changes."

## Step 1.0 — Audit (no code changes)

Report findings; do not modify anything yet.

- **Where is the login shell set?** Search `nixos/` for
  `users.users.marcus.shell` / `programs.fish.enable`. This is set on the NixOS
  side and *must* change to bash, otherwise removing the fish home-manager
  config leaves a login shell whose config no longer exists.
- **Fish-specific integrations.** Grep `home-manager/profiles/maximal/` for
  anything that hooks fish specifically: `programs.direnv.enableFishIntegration`,
  `programs.zoxide.enableFishIntegration`, `xdg.configFile."fish/..."`,
  `programs.fzf.enableFishIntegration`. Each needs a bash equivalent.
- **What does the suckless bash config already contain?** Read
  `home-manager/profiles/suckless/` and list: PS1/prompt definition, aliases,
  fzf bindings, zoxide init, history settings.
- **What does the suckless foot config contain?** In particular, does it set
  colours explicitly from `colors.nix`?
- **Does stylix theme ghostty on maximal?** Check for `stylix.targets.ghostty`
  or implicit theming.
- **Terminal spawn keybinds.** Find every place a terminal is launched:
  Hyprland binds, dwl config, walker/wmenu terminal setting, any
  `TERMINAL` env var, `xdg.mimeApps` terminal association.

Output a short report covering each bullet. Do not proceed until the human
confirms.

## Step 1.1 — Promote bash to core

Move the bash configuration from `home-manager/profiles/suckless/` to
`home-manager/core/`. Add bash equivalents of every fish integration found in
1.0 (direnv, zoxide, fzf).

Do **not** remove fish yet. After this step maximal hosts have both bash and
fish configured; fish is still the login shell. Nothing about maximal's runtime
behaviour changes.

- Buildable: all 6 targets.
- Expected diff: `bash` config appears in the maximal home closures. No removals.

## Step 1.2 — Switch login shell, remove fish and starship

- Set the login shell to bash on the NixOS side for all hosts.
- Remove `fish` and `starship` from `home-manager/profiles/maximal/`.
- Ensure the core bash config defines a prompt. Starship was providing it on
  maximal; if the suckless PS1 is bare, this is the moment to make it decent.

- Buildable: all 6 targets.
- Expected diff: `fish`, `starship` gone from maximal home closures.

## Step 1.3 — Promote foot to core

Move the foot configuration from `home-manager/profiles/suckless/` to
`home-manager/core/`.

**Stylix conflict — the non-obvious part.** Stylix has a foot target and
auto-enables it. Once foot is in core, stylix on the maximal hosts will try to
theme it, potentially fighting the explicit palette from
`home-manager/profiles/suckless/colors.nix`. Pick one and be explicit:

- **Option A (recommended for Phase 1):** keep the explicit base24 colours in
  the shared foot config and set `stylix.targets.foot.enable = false;` in the
  maximal profile. Identical terminal colours everywhere, no surprises.
- **Option B:** strip explicit colours from the shared foot config and let
  stylix drive it on maximal, base24 on suckless. Colours may drift slightly
  between hosts since one path is base16 and one is base24.

Take Option A unless the human says otherwise. Do not leave it implicit —
whichever is chosen, write the option down in the file.

Ghostty stays installed for now.

- Buildable: all 6 targets.
- Expected diff: `foot` appears in the maximal home closures.

## Step 1.4 — Foot daemon mode

New on **both** profiles, so this is the riskiest step of Phase 1. Isolate it.

- Enable the foot server as a systemd user service (`services.foot` if the
  home-manager module provides it, otherwise a `systemd.user.services.foot`
  unit running `foot --server`).
- Change every terminal spawn point found in 1.0 to `footclient`.
- Keep a fallback binding to plain `foot` on a different key. If the daemon is
  not running, `footclient` fails silently and you have no terminal — which is
  a bad thing to discover on a fresh boot with no other terminal open.

- Buildable: all 6 targets.
- **Human verification required before continuing:** switch on `UM790pro`,
  confirm `footclient` opens a terminal, confirm it survives a logout/login,
  confirm the fallback works.

## Step 1.5 — Retire ghostty

Remove ghostty from the maximal profile. Do not delete the file — move it to
`home-manager/_dormant/ghostty.nix` and leave it unimported, so it survives
into Phase 2 as a back-pocket module.

- Buildable: all 6 targets.
- Expected diff: `ghostty` gone from maximal home closures.

## Phase 1 exit criteria

- All 6 targets build.
- Human has switched all three hosts and used them for several days.
- `main` is committed and pushed.

---

# Phase 2 — Dendritic migration

**Orphan branch. Home Manager stays standalone.**

The strategy is *shims*: stand up the new flake structure immediately with
aspects that just re-import the existing legacy directories, verify that the
build output is byte-identical, then peel out one real aspect at a time.

The success criterion for the whole phase is mechanical: **the six output store
paths must be identical to Phase-1 `main`.** Not "similar." Identical.

## Step 2.0 — Branch and baseline

```bash
git switch --orphan dendritic          # NOT git checkout --orphan
git restore --source=main --worktree -- flake.lock
git restore --source=main --worktree -- 'hosts/*/hardware-configuration.nix'
git worktree add ../dotfiles-old main
mkdir -p scripts && cp <verify.sh> scripts/verify.sh && chmod +x scripts/verify.sh
git add -A && git commit -m "phase2: baseline"
```

`flake.lock` must come from `main` — if nixpkgs resolves differently, every
diff is noise and the safety net is gone. `hardware-configuration.nix` is not
regenerable without physical access to each machine.

Sanity check the baseline before writing any new code:

```bash
./scripts/verify.sh
```

Comparing `main` against itself must report six PASS lines. If it doesn't, stop
and diagnose — see "When paths differ for boring reasons" below.

## Step 2.1 — Scaffolding with shims

Create:

**`flake.nix`** — inputs unchanged from Phase 1, plus `flake-parts` and
`import-tree`:

```nix
{
  description = "My system configuration";

  inputs = {
    # ... all existing inputs, unchanged, same pins ...
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; }
      (inputs.import-tree ./modules);
}
```

Then `git add -A && nix flake lock` — this *adds* the two new nodes without
touching existing pins. Verify `nixpkgs` in `flake.lock` still matches `main`.

**`modules/_legacy/shims.nix`** — the `_` prefix means import-tree skips it, so
it is wired by hand:

```nix
{ ... }:
{
  flake.legacy = {
    nixosHost = hostname: ../../hosts/${hostname}/configuration.nix;
    homeEntry = ../../home-manager/home.nix;
  };
}
```

(Declare `flake.legacy` as an option, or use `_module.args` — whichever the
agent finds cleaner. It is temporary either way.)

**`modules/hosts/<hostname>.nix`** — one per host, carrying exactly the data
from the old `hosts` list:

```nix
{ ... }:
{
  flake.hostRecords.swift5 = {
    hostname = "swift5";
    system = "x86_64-linux";
    stateVersion = "25.11";
    profile = "suckless";
    dev = true;
  };
}
```

**`modules/lib/mk-hosts.nix`** — the generator. This is the hard 20% of Phase 2.
It must reproduce the old `makeSystem` and `mkHome` **exactly**:

- `specialArgs = { inherit inputs stateVersion hostname user monitors profile dev; }`
- `modules = [ { nixpkgs.hostPlatform = system; } ./hosts/${hostname}/configuration.nix ]`
- `extraSpecialArgs = { inherit inputs user hostname homeStateVersion monitors sensitivity profile dev; }`
- `pkgs = nixpkgs.legacyPackages.${system}` for home — **not** an overlaid
  `import nixpkgs {...}`. Changing this changes every home store path.
- home modules = `lib.optionals (profile == "maximal") [ stylix.homeModules.stylix walker.homeManagerModules.default ] ++ [ ./home-manager/home.nix ]`

### The `monitors` asymmetry — do not "fix" this

The old flake passes two **different shapes** under the same name:

```nix
# NixOS side — the whole attrset returned by monitors.nix
monitors = import ./hosts/${hostname}/monitors.nix utils;

# Home side — only the .monitors attribute
monitorConfig = import ./hosts/${hostname}/monitors.nix utils;
inherit (monitorConfig) monitors;      # <- monitors.monitors
inherit (monitorConfig) sensitivity;
```

So NixOS modules see `monitors = { monitors = ...; sensitivity = ...; }` and
home modules see `monitors = [ ... ]`. This looks like a bug and it may well be
one, but the legacy modules are written against it. Reproduce it exactly.
Fixing it belongs in the post-migration cleanup, after the rename.

### `profile` and `dev` stay for now

They cannot be deleted until the last legacy module that reads them has been
peeled out. Keep threading them through `specialArgs` for the whole shim phase.
Removing them is Step 2.8.

- **Verify: `./scripts/verify.sh` must report 6 PASS.** Nothing else counts as
  done for this step. If any target differs, the generator is not faithful yet.

## Steps 2.2–2.7 — Peel aspects, safest first

For each aspect: create `modules/<domain>/<name>.nix` defining
`flake.modules.<class>.<aspect>`, add the aspect name to the relevant host
records, remove the corresponding import from the legacy entry point, then run
`./scripts/verify.sh`. **6 PASS or revert.** One aspect per commit.

Order matters — leaf modules with no cross-class coupling first:

- **2.2 Home core leaves.** bash, foot, git, firefox, cli tools, tmux, neovim
  wrapper. Pure home-manager, no NixOS side, no `profile` conditionals.
- **2.3 NixOS core leaves.** boot, audio, networking, nix settings, nh, ly.
- **2.4 `dev`.** `nixos/dev/` becomes `flake.modules.nixos.dev`, named in the
  `swift5` and `UM790pro` aspect lists. The `dev` boolean is now redundant on
  the NixOS side, but keep passing it until 2.8 in case home modules read it.
- **2.5 `suckless`.** Merge `nixos/profiles/suckless` and
  `home-manager/profiles/suckless` into `modules/suckless/*.nix`, each file
  defining both classes. The dwl bar-patch overlay lives here too — but note
  that with standalone HM on `legacyPackages`, an overlay declared in the flake
  does **not** reach home configs. Keep whatever mechanism currently gets the
  patched dwl into the closure; do not switch to `flake.overlays` in this phase.
- **2.6 `maximal`.** Same treatment. Hyprland, waybar, walker, stylix wiring.
  The conditional stylix/walker imports in the generator become part of the
  `maximal` aspect.
- **2.7 Host-local.** `hosts/<h>/configuration.nix`, `local-packages.nix`,
  `monitors.nix` fold into `modules/hosts/<hostname>.nix`.
  `hardware-configuration.nix` stays a plain file, imported by path.

  `monitors.nix` stays a `utils`-taking function passed through `specialArgs`
  unchanged — see the asymmetry warning above. **But write the host file so
  that Phase 3 is a swap, not a restructure:** keep the monitor passthrough
  isolated in its own clearly-marked block rather than interleaved with package
  lists and hardware imports, so it can be replaced wholesale later.

## Step 2.8 — Flatten

Only once no legacy module reads them:

- Remove `profile` and `dev` from `specialArgs` / `extraSpecialArgs`.
- Delete `modules/_legacy/`.
- Delete `nixos/`, `home-manager/`, `hosts/*/configuration.nix`.
- Host files now list aspect names and nothing else.

- **Verify: 6 PASS.** This is the important one. If the paths still match after
  the legacy tree is gone, the migration is provably behaviour-neutral.

## Step 2.9 — Rename (human does this)

Do not rename until at least one host has switched and rebooted successfully —
`swift5` first, since it is the odd one out.

```bash
git branch -m main main-legacy
git branch -m dendritic main
git push origin main-legacy
git push --force-with-lease origin main
git worktree remove ../dotfiles-old
```

---

# Phase 3 — Typed monitor declarations

**Runs on the new `main`, after the Phase 2 rename.**

Why not during Phase 2: this changes generated config content, which changes
store paths, which breaks the neutral-diff proof. It cannot be verified with
`verify.sh` in compare mode. Once the rename has happened the baseline is
retired and `./scripts/verify.sh build` becomes the check.

## What is wrong with the current shape

Three separate problems, only one of which is the asymmetry:

1. **It is a builder, not data.** `import ./hosts/<h>/monitors.nix utils`
   returns something already rendered for a particular consumer. That is why
   the two call sites destructure it differently. Pre-rendered data can only
   serve the consumer it was rendered for.
2. **`sensitivity` is smuggled in.** Pointer sensitivity is not a display
   property. Its presence reveals the file's real identity: "per-host
   input/output bag."
3. **Nothing is typed.** A typo in a connector name or a missing `scale`
   surfaces as a broken compositor config at runtime, not an eval error.

## Step 3.1 — Declare the option

`modules/display/monitor-option.nix`. Declare at the flake-parts top level
(`options.hosts`), **not** under `flake.*` — it should be readable during eval
without becoming a flake output. This placement matters because NixOS and
standalone Home Manager are separate module evaluations sharing no `config`;
flake-parts is the only level both can read from.

```nix
{ lib, ... }:
let
  monitor = lib.types.submodule ({ config, ... }: {
    options = {
      name        = lib.mkOption { type = lib.types.str; };          # "DP-1"
      description = lib.mkOption { type = lib.types.nullOr lib.types.str; default = null; };
      width       = lib.mkOption { type = lib.types.ints.positive; };
      height      = lib.mkOption { type = lib.types.ints.positive; };
      refresh     = lib.mkOption { type = lib.types.numbers.positive; default = 60; };
      x           = lib.mkOption { type = lib.types.int; default = 0; };
      y           = lib.mkOption { type = lib.types.int; default = 0; };
      scale       = lib.mkOption { type = lib.types.numbers.positive; default = 1.0; };
      transform   = lib.mkOption { type = lib.types.ints.between 0 7; default = 0; };
      enabled     = lib.mkOption { type = lib.types.bool; default = true; };
      primary     = lib.mkOption { type = lib.types.bool; default = false; };
      vrr         = lib.mkOption { type = lib.types.nullOr (lib.types.ints.between 0 2); default = null; };
      workspaces  = lib.mkOption { type = lib.types.listOf lib.types.str; default = []; };

      mode = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = "${toString config.width}x${toString config.height}@${toString config.refresh}";
      };
    };
  });
in
{
  options.hosts = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        monitors = lib.mkOption { type = lib.types.listOf monitor; default = []; };
        input.sensitivity = lib.mkOption { type = lib.types.float; default = 0.0; };
      };
    });
    default = { };
  };
}
```

- Buildable: nothing consumes it yet, so all 6 targets are unchanged.

## Step 3.2 — Renderers

`modules/display/render.nix`, exposing `flake.lib.monitors`:

- `toHyprland` — the `monitor=` string. Prefer `desc:${description}` over
  `name` when a description is present.
- `toDwlRule` — a `MonitorRule` struct line for `config.h`.
- `outputNames` — enabled connector names, for waybar's per-output bars and the
  wallpaper rotator.
- `primaryOf` — the primary monitor, falling back to the head of the list.

Add assertions in the same file:

```nix
assertions = [
  { assertion = lib.length (lib.filter (m: m.primary) ms) <= 1;
    message = "host ${name}: more than one primary monitor"; }
  { assertion = lib.length (lib.unique (map (m: m.name) ms)) == lib.length ms;
    message = "host ${name}: duplicate connector names"; }
  { assertion = ms == [] || lib.any (m: m.enabled) ms;
    message = "host ${name}: all monitors disabled"; }
];
```

That last one prevents a black-screen boot.

- Buildable: still nothing consumes it. All 6 targets unchanged.

## Step 3.3 — Migrate hosts one at a time

**One host per commit**, starting with `swift5` (single internal panel, lowest
risk, and it exercises the dwl path).

For each host: write the typed data in `modules/hosts/<h>.nix`, point that
host's compositor aspect at the renderer, drop `monitors` and `sensitivity`
from its `specialArgs`.

```nix
hosts.UM790pro = {
  monitors = [
    { name = "DP-1"; width = 3440; height = 1440; refresh = 165;
      primary = true; workspaces = [ "1" "2" "3" "4" "5" ]; vrr = 1; }
    { name = "HDMI-A-1"; width = 1920; height = 1080;
      x = 3440; y = 360; workspaces = [ "6" "7" "8" ]; }
  ];
  input.sensitivity = -0.3;
};
```

**Verify by diffing the generated config text, not store paths.** Before
migrating a host, dump its current Hyprland `monitor=` lines (or dwl
`MonitorRule` block) to a file. After migrating, dump again and `diff`. The
lines should be semantically identical — if the renderer emits a different
scale or offset, that is a renderer bug, not an improvement.

- Buildable after each host. `./scripts/verify.sh build` must pass all 6.
- **Human must switch and confirm displays come up correctly before the next
  host.** Do not migrate all three and then test.

Note the dwl path differs in kind: `config.h` is compile-time, so a monitor
change on `swift5` recompiles dwl rather than reloading. A couple of seconds,
but expect it.

## Step 3.4 — Retire the passthrough

Once all three hosts are migrated: delete `hosts/*/monitors.nix`, remove
`monitors` / `sensitivity` from both `specialArgs` and `extraSpecialArgs`,
delete `utilities/` if nothing else uses it.

The shape asymmetry dies here on its own — there is no `specialArgs` left to be
inconsistent about.

## Open design decision (human answers before 3.1)

**Match by connector name or description?** `DP-1` is positional and can shift
when cables are replugged or a dock enumerates differently. Hyprland supports
`desc:Dell Inc. DELL U2720Q ABC123`, stable across ports. dwl only supports
connector names, so `swift5` cannot use descriptions regardless.

Recommendation: `name` required, `description` optional, `toHyprland` prefers
description when present. Get descriptions with `hyprctl monitors -j`.

---

## Other post-migration cleanups (unordered, low priority)

- Consolidate theming: one palette source of truth feeding both stylix (base16
  subset) and the suckless base24 consumers.
- Consider `pkgs = import nixpkgs { overlays = [...]; }` for home configs so
  overlays reach Home Manager. Affects every home store path — its own commit.

---

## When paths differ for boring reasons

If `verify.sh` reports FAIL but the change looks innocent, check these before
assuming the refactor is wrong:

- **`system.configurationRevision = self.rev`** or similar. The orphan branch
  has a different git revision, so this differs by construction. Comment it out
  for the duration of Phase 2, or exclude it from comparison.
- **`nix.registry.nixpkgs.flake = inputs.nixpkgs`** — pins a flake source path
  into the system closure.
- **`environment.etc` entries embedding the flake source path.**
- **`flake.lock` drift.** `diff flake.lock ../dotfiles-old/flake.lock` and
  confirm the `nixpkgs` node is identical. The two new nodes (flake-parts,
  import-tree) are expected; anything else is not.

---

## Known agent failure modes

- **Inventing flake-parts option paths.** `flake.homeModules` and
  `flake.homeManagerModules` both look plausible and are both wrong. The aspect
  pattern uses `flake.modules.homeManager.<name>` and
  `flake.modules.nixos.<name>`. Wrong paths fail with type errors, not
  "no such option."
- **`config` shadowing.** Inside `flake.modules.nixos.foo = { config, ... }: ...`,
  `config` is the *NixOS* config, not flake-parts'. Capture the flake-parts one
  in an outer `let` under a different name (`fp`, `top`) or you get infinite
  recursion.
- **Forgetting `git add -A`.** Causes "path does not exist" on files that
  visibly exist. Especially bad on a fresh orphan branch where nothing is
  tracked.
- **Helpful improvements.** Bumping a package, tidying an option, "fixing" the
  monitors asymmetry. Any of these break the neutral-diff proof. `verify.sh`
  catches them, which is why it runs every step.

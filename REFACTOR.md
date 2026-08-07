# Refactor Plan: roles as aspects, intents as options

`CLAUDE.md` holds the invariants. Do not restate them here — read them there. This document
only says what to do next, in what sequence, and how to know it worked.

**The previous plan is finished and has been replaced.** Steps 0–7 of it closed §12 items
1–6; the structural invariants in §1 now hold. That plan, with its per-step measurements,
is in git history:

```bash
git log --oneline --all -- REFACTOR.md
```

Three later commits this plan builds on directly: `4137d7a` typed the host record,
`bf52982` added `aspectRequires` and the generator check that enforces it, and `f7d40f4`
introduced the first role option, `fileManager.command`.

---

## Progress

Update this list in the commit that completes each step. It is the only record of where the
work is — the plan is otherwise stateless, and a fresh session will start at the top.

- [ ] **Step 1** — `mako` moves to `core`
- [ ] **Step 2** — `thunar` becomes an aspect
- [ ] **Step 3** — `wleave` becomes an aspect; `powerMenu.command`
- [ ] **Step 4** — `waybar` becomes an aspect; `bar.toggle`; dwl's bar patch becomes conditional
- [ ] **Step 5** — `walker` and `wmenu` become aspects; `launcher.argv` becomes strict
- [ ] **Step 6** — `terminal.argv`, provided from `core`

---

## The principle

Two mechanisms, applied by a single test:

- **Does a host refuse it?** → an **aspect**. §3's existing test, unchanged.
- **Do two implementations answer the same question?** → an **option namespace** in `core`,
  set by whichever aspect provides it.

A role gets both when both apply.

**Two things claiming one job is an error.** This falls out of the second mechanism at no
cost: a single-valued option with two definitions is a module-system conflict, and because
aspect elements are `deferredModule` (§9) the error names the files rather than reporting
`<unknown-file>` twice:

```
error: The option `terminal.argv' has conflicting definition values:
  - In `.../modules/foot.nix': [ "/nix/store/…/footclient" ]
  - In `.../modules/ghostty.nix': [ "/nix/store/…/ghostty" ]
```

**This constrains claiming the role, not installing the package.** Nothing stops a second
terminal appearing in `home.packages`; the error fires only when two things both claim to
*be* the terminal. That is the intended line — trying a second terminal is legitimate, two
things silently fighting over `$mod+Return` is not.

---

## Role inventory

| Role | Intent option | Provider | Aspect today | Proposed aspect | Refused by |
| --- | --- | --- | --- | --- | --- |
| launcher | `launcher.argv` *(exists)* | walker | `apps` | **`walker`** | swift5 |
| launcher | ” | wmenu | set inline in `dwl` | **`wmenu`** | gpc, UM790pro |
| bar | **`bar.toggle`** *(new)* | waybar | `hyprland` | **`waybar`** | swift5 |
| bar | ” | dwl built-in | `dwl` (C patch) | stays in `dwl` | — |
| file manager | `fileManager.command` *(done, `f7d40f4`)* | thunar | `apps` | **`thunar`** | swift5 |
| power menu | **`powerMenu.command`** *(new)* | wleave | `apps` | **`wleave`** | swift5 |
| terminal | **`terminal.argv`** *(new)* | foot | `core` | stays `core` | nobody |
| notifications | none — §7 says no intent | mako | `palette`+`stylix`+`laptop` | **moves to `core`** | nobody |
| browser | none — see *Deliberately absent* | firefox | `core` | stays `core` | nobody |

Net: **five new aspects** — `walker`, `wmenu`, `waybar`, `wleave`, `thunar` — taking the
repo from ten to fifteen.

### Three roles deliberately get no aspect

§3's test is "does some host say no". These three fail it, and inventing a name anyway
would be exactly the per-tool selection §3 warns turns each host into a duplicated
manifest.

- **mako.** Every host has it today, via `palette` *or* `stylix`. It does not earn an
  aspect; it earns *escape from theming*. `dwl.nix`'s session autostart invokes `mako` by
  bare name, so today a dwl host taking neither theming aspect gets no notification daemon
  — a capability made conditional on a theming regime. Moving it to `core` fixes that
  without adding a name.
- **foot, firefox.** Single implementations nobody refuses. `foot` gets the *option* so
  consumers stop hardcoding it; both stay in `core`. If ghostty ever arrives as an aspect,
  taking it produces the conflict error above, and *that* is the moment foot earns its own
  aspect.

### Deliberately absent

- **`browser.command`.** Nothing binds a browser key, so the option would have a setter and
  no reader — precisely what §7 warns against. Add it when something reads it.
- **A `bar` aspect distinct from `waybar`.** The dwl built-in bar is compiled into dwl; it
  is not separable from the `dwl` aspect and does not want a name of its own.

---

## Semantics: strict, not `mkDefault`

Sessions stop setting role options. `launcher.nix`'s `hyprland` and `dwl` branches both go
away; `walker` and `wmenu` set `launcher.argv` themselves.

| Case | Result |
| --- | --- |
| Two providers | module-system conflict, naming both files |
| Zero providers | `option used but not defined` |
| Session opinion | none — the host list is the only statement |

`mkDefault` is rejected on purpose: it is the mechanism for silently resolving exactly what
this plan wants to be loud. Do not reach for it to make a step build.

**Known weakness, accepted.** The zero-provider error names the option but not the host, and
`aspectRequires` cannot express "needs one of {walker, wmenu}". The alternative is a
`roleProviders` count in the generator. Accept the weaker error for now; revisit only if it
actually bites.

---

## Resulting host files

```nix
swift5   = ["dev" "core" "laptop" "dwl" "wmenu" "palette"];                    # 5 → 6
gpc      = ["core" "gaming" "nvidia" "hyprland" "waybar" "walker" "wleave"
            "thunar" "stylix" "apps"];                                          # 6 → 10
UM790pro = ["dev" "core" "hyprland" "waybar" "walker" "wleave" "thunar"
            "stylix" "apps"];                                                   # 5 → 9
```

The case that motivated the plan becomes expressible for the first time:

```nix
someone = ["core" "dwl" "walker" "waybar" "palette"];   # dwl, walker, waybar, no wmenu
```

---

## Ground rules

`CLAUDE.md` §9, §10 and §13 apply in full. The ones that bite hardest here:

- **This is not a byte-identical refactor.** Every host moves. Files changing aspect change
  `buildEnv` order (§5), and several steps are behavioural besides. `verify.sh` is used here
  to *explain* diffs, not to demand zero — a different discipline from the commits that
  preceded this plan, where byte-identity was the pass condition. Each step below states its
  own expectation; treat a deviation from that as the signal.

  | Step | swift5 | gpc | UM790pro |
  | --- | --- | --- | --- |
  | 1 mako → core | **changes** | **changes** | **changes** |
  | 2 thunar aspect | identical | **changes** | **changes** |
  | 3 wleave aspect | identical | **changes** | **changes** |
  | 4 waybar aspect | identical | **changes** | **changes** |
  | 5 walker/wmenu | **changes** | **changes** | **changes** |
  | 6 terminal.argv | **changes** | **changes** | **changes** |

- **Aspect order in a host list is load-bearing.** It sets module merge order, which reaches
  derivation hashes. When splitting one aspect into two, put the new names where the old one
  sat so the split is a partition, not a reordering.
- **What reaches store paths is the relative order of files contributing to the *same*
  aspect.** `import-tree` walks depth-first, per-directory alphabetical (§5). `home.packages`
  is the concatenation over the aspect list, so interleaving files of *different* aspects is
  invisible — the aspect list already separated them. Within-aspect rank only reaches the
  output when two files contribute to the same list-valued option. Measure rather than
  predict; the previous plan recorded three occasions where sound reasoning about this
  reached the wrong conclusion.
- **Declare before you reference.** The generator rejects an aspect name that resolves in no
  class, so a commit adding a name to a host list before the declaring file exists will not
  evaluate. Land the file first, or both in one commit — otherwise a bisect lands on a
  broken tree.
- **`aspectRequires` moves with the file.** A file carrying `aspectRequires.<aspect>` that
  changes aspect must change its requirement key in the same edit, or the requirement
  silently attaches to an aspect that no longer reads stylix. Steps 2–5 all move such files.
- **One concern per commit.** These steps move store paths by design; small commits are what
  make a bisect possible.
- **The human switches and confirms before the next step.** Every step here is marked
  **changes** for at least one host. This is not restated per-step; absence is not
  permission.

### Verification

`./scripts/verify.sh build` must report 6 OK before every commit. Then compare against the
previous commit — `verify.sh` takes a git ref and manages its own worktree:

```bash
./scripts/verify.sh HEAD~1
```

That compares output paths only. When a step is expected to change them, the question is
*what* changed, which needs the deeper diff:

```bash
git worktree add ../dotfiles-prev <previous-commit>

for h in swift5 gpc UM790pro; do
  echo "=== $h ==="

  old=$(nix build --no-link --print-out-paths \
        "../dotfiles-prev#homeConfigurations.\"marcus@$h\".activationPackage")
  new=$(nix build --no-link --print-out-paths \
        ".#homeConfigurations.\"marcus@$h\".activationPackage")

  nix store diff-closures "$old" "$new"          # which packages moved
  diff -rq "$old/home-files" "$new/home-files"   # which generated files moved

  # diff-closures alone is NOT sufficient: a module that vanishes while setting
  # only config values adds no package, so the closure is unchanged.
  oldt=$(nix build --no-link --print-out-paths \
         "../dotfiles-prev#nixosConfigurations.$h.config.system.build.toplevel")
  newt=$(nix build --no-link --print-out-paths \
         ".#nixosConfigurations.$h.config.system.build.toplevel")

  diff -rq "$oldt/etc" "$newt/etc" 2>&1 | grep -v "^diff:.*No such file"
done

git worktree remove ../dotfiles-prev
```

The `grep -v` drops dangling-symlink noise, which is expected and not a real difference.

### When paths differ for boring reasons

A step marked **changes** should still be *explained*. These are the innocent causes;
anything outside them deserves a second look before the commit.

- **`buildEnv` order.** A file moving between aspects changes where its packages land in the
  concatenation over the host's aspect list. `nix store diff-closures` prints nothing —
  same packages, same versions — while the output path differs. This is the expected
  signature of Steps 2–5.
- **A generated config gaining or losing a line.** `diff -rq` names the file;
  `diff` it directly. A keybind that disappears because its provider is absent is the
  intended behaviour of this plan, not a regression.
- **Theming reaching a program it did not reach before.** Moving a file between `palette`,
  `stylix` and `core` changes which programs stylix's explicit target list covers (§9). Step
  1 does this to mako deliberately.

Not innocent, and worth stopping for: a package appearing or disappearing from
`diff-closures` that the step did not intend, a version change, or a diff on a host the step
predicted would be identical.

---

## Step 1 — `mako` moves to `core`

Smallest, independent of everything else, and a good canary for the diff-explaining
workflow.

`mako.nix` declares `homeManager.laptop`, `homeManager.palette` and `homeManager.stylix`.
Notifications are a capability every host wants; the theming split is about *how mako
looks*, not *whether it exists*.

- Move the daemon's existence and its shared settings to `core`.
- Keep the two theming regimes where they are: `palette` and `stylix` continue to set
  colours only.
- The battery rule (`de9094b`) follows the battery, so it stays in `laptop`.

Closes the audit finding that `dwl.nix`'s autostart invokes `mako` by bare name from a
theming aspect.

**Expect:** all three hosts change. Watch for stylix theming mako differently once the
daemon is declared in `core` — §9's warning about moving a themed program between aspects
applies directly.

## Step 2 — `thunar` becomes an aspect

`fileManager.command` already exists (`f7d40f4`), so this is purely the aspect move.

- `thunar.nix`'s `nixos.apps` and `homeManager.apps` contributions become `nixos.thunar` and
  `homeManager.thunar`. The `homeManager.core` option declaration stays in `core`.
- Add `thunar` to gpc and UM790pro, positioned where `apps` sits so the split is a partition.
- `mime.nix:8` sets `"inode/directory" = "thunar.desktop"` from `core`, which swift5 already
  carries with no thunar behind it. Move that association into `thunar.nix`. The same file
  names `vesktop.desktop` and `thunderbird.desktop`, both `apps` — fix those in the same
  commit or state why not.

**Expect:** swift5 identical, gpc and UM790pro change.

## Step 3 — `wleave` becomes an aspect; `powerMenu.command`

- Declare `options.powerMenu.command` in `core`; `wleave.nix` sets it.
- `wleave.nix` moves from `homeManager.apps` to `homeManager.wleave`.
- `wleave.nix:24` hardcodes `hyprlock` and `:31` hardcodes `hyprctl dispatch`, both from the
  `apps` aspect while only `hyprland` installs them. Replace the lock action with
  `config.lock.command`, which `lock.nix` already publishes and `hypridle.nix` already reads.
  Omit the button when it is empty rather than rendering a dead one.
- `hyprland-binds.nix` and `waybar.nix:130` read `config.powerMenu.command` and omit their
  entries when empty.

**Expect:** swift5 identical, gpc and UM790pro change.

## Step 4 — `waybar` becomes an aspect; `bar.toggle`

The largest step. Both sessions already bind `$mod+B` to "toggle the bar" by completely
different means — `hyprland-binds.nix:39` shells out to `systemctl --user`, `dwl.nix:154`
compiles `togglebar` into C. That is §3's intent/implementation split exactly.

- Declare `options.bar.toggle` in `core`, default `""`.
- `waybar.nix`, `waybar-style.nix` and `waybar-scripts.nix` move from `homeManager.hyprland`
  to `homeManager.waybar`; `waybar.nix` sets `bar.toggle`.
- `hyprland-binds.nix` renders the `$mod+B` bind only when `bar.toggle != ""`.
- `dwl.nix` compiles its bar patch only when no external bar is present:

  ```nix
  patches = (old.patches or []) ++ lib.optional (config.bar.toggle == "") barPatch;
  ```

  and drops the `togglebar` bind at `dwl.nix:154` in the same condition. A dwl host taking
  `waybar` compiles without the patch and binds `$mod+B` to the option instead.

This branch is on a *capability*, not on compositor identity, so §3's prohibition on an
aspect branching between dwl and Hyprland does not apply.

**Expect:** swift5 identical, gpc and UM790pro change. Note `waybar.nix:8` currently targets
`wayland-session@hyprland.desktop.target`, which hard-codes the desktop-entry id; converging
it onto `graphical-session.target` belongs in this step or immediately after.

## Step 5 — `walker` and `wmenu` become aspects; `launcher.argv` becomes strict

Do this last. It is the step with the conflict semantics, and Steps 1–4 will have proven the
pattern.

- `walker.nix` moves from `homeManager.apps` to `homeManager.walker` and sets
  `launcher.argv = ["walker"]`. Its `aspectRequires.apps = ["stylix"]` becomes
  `aspectRequires.walker`.
- A new `wmenu` aspect takes the wmenu setter currently inline in `launcher.nix`'s `dwl`
  branch, including `config.wmenu.flags`.
- `launcher.nix` keeps only the `core` option declaration. Both session branches go.
- `clipboard.nix:25` sets `clipboard.history = "walker -m clipboard"` from `hyprland`;
  that setter moves to the `walker` aspect. The `$mod+Tab` and `$mod+W` binds in
  `hyprland-binds.nix` name walker directly and need the same treatment or a reader guard.
- `hyprpaper-picker.nix` writes `elephant/menus/wallpapers.lua` from `hyprland` for a backend
  only walker supplies — it moves too, or gains a guard.

**Expect:** all three hosts change. This is where the "two launchers is an error" property
first becomes real; verify it by adding both `walker` and `wmenu` to a scratch host and
confirming the conflict names both files.

## Step 6 — `terminal.argv`, provided from `core`

Independent of Steps 1–5; can slot anywhere after Step 1.

`hyprland-binds.nix:12-13` holds `terminal` and `terminalFallback` as bare `let` bindings;
`dwl.nix:25-26` interpolates foot's store path for the same two roles.

- Declare `options.terminal.argv` and `terminal.fallbackArgv` in `core`, with
  `terminal.command` as the read-only shell rendering, mirroring `launcher`.
- `foot.nix` sets both, by store path — `${pkgs.foot}/bin/footclient` and
  `${pkgs.foot}/bin/foot`.
- Both sessions read them. dwl uses the argv form directly in its C array; hyprland renders
  `uwsm app -- ${terminal.command}`.

Using a store path rather than the bare `footclient` removes a `PATH` dependency, which §3
prefers where the consumer can hold a path.

**Expect:** all three hosts change — the generated `hyprland.lua` and `config.h` both gain
store paths where they had bare names.

---

## Not now

**Darwin is parked.** `systems` stays `["x86_64-linux"]` and `mbp` remains planned rather
than present; `CLAUDE.md` §12 item 7 records the divergence and its §7 guidance on class
placement still stands. Nothing in this plan should be shaped around a Mac that does not
exist.

One consequence to record rather than act on: every role option in this plan is set by a
Linux aspect, so an `mbp` taking one of these aspects would set a role option with no darwin
provider behind it — the dead-bind failure this plan exists to remove. Whoever picks darwin
back up starts there.

Also parked, and deliberately not steps:

- **`_class` enforcement on aspect elements.** Investigated and rejected: the aspect
  attribute path is the only statement of intent, so a stamp derived from it cannot disagree
  with itself. Stamping via `deferredModuleWith { staticModules }` produced an identical
  unhelpful error and moved all six store paths.
- **Whether `apps` survives.** After Steps 2–5 it holds neovim, tmux, discord, thunderbird,
  opencode and bat. That is a genuine bundle, but "the extra applications" is close to the
  magnitude naming §3 rejects. Revisit once the roles are out of it, not before.
- **Overlays reaching Home Manager.** Changing `pkgs` for home configs moves every home
  store path; its own project, with its own switch cycle.
- **Quickshell.** Waybar and walker stay.

---

## Done means

- Five new aspects exist — `walker`, `wmenu`, `waybar`, `wleave`, `thunar` — and each is
  refused by at least one host.
- `mako` is in `core`; no capability is conditional on a theming regime.
- No role is named by a bare `let` binding in a session's config. `launcher`, `bar`,
  `terminal`, `fileManager` and `powerMenu` are options in `core`, set by providers and read
  by sessions.
- A host taking two providers of one role fails to evaluate, with an error naming both
  files. Verified by scratch host, not asserted.
- A dwl host can take `walker` and `waybar`, and a Hyprland host can take neither.
- No bare-name tool invocation crosses from an aspect that does not install it — the audit's
  P2 class is closed, not just its thunar instance.

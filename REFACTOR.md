# Refactor Plan: retire stylix, theme from the palette

`CLAUDE.md` holds the invariants. Do not restate them here — read them there. This document
only says what to do next, in what sequence, and how to know it worked.

**The roles plan is finished and has been replaced.** It closed with three new aspects
(`waybar`, `wleave`, `thunar`), eight role options, and two of its own claims disproved. It
is in git history, with its per-step measurements:

```bash
git log --oneline --all -- REFACTOR.md
```

It also recorded this project under *Not now*, and the reason it was parked: retiring stylix
empties the `stylix` aspect and dissolves every `aspectRequires.<a> = ["stylix"]` in the
tree, so it is not a change to make while something else is moving.

---

## Why

stylix is an input that generates theming from a base16 scheme. It is one more dependency in
the chain, and it has shipped deprecated config against home-manager without fixing it. The
theming it produces is not hard to write by hand, and this repo already writes half of it —
`palette` exists precisely because swift5 does not carry stylix.

The end state is **one theming path, not two**. `desktop.colors` in `core` is the only source
of colour; fonts, cursor and icons are set directly. Both the `stylix` and `palette` aspect
names disappear, because a host does not decide *how* it is themed — it is themed.

---

## The enabling measurement

`colors.nix`'s base24 palette and the `kanagawa-dragon.yaml` stylix loads are **the same
sixteen colours**. Checked, not assumed:

```bash
nix eval --raw --impure --expr '
let hm = (builtins.getFlake (toString ./.)).homeConfigurations."marcus@UM790pro".config;
in builtins.concatStringsSep "\n" (map (k:
     "${k} ${if "#" + hm.lib.stylix.colors.${k} == hm.desktop.colors.${k}
             then "same" else "DIFFER"}")
   ["base00" "base01" "base02" "base03" "base04" "base05" "base06" "base07"
    "base08" "base09" "base0A" "base0B" "base0C" "base0D" "base0E" "base0F"])'
```

All sixteen `same`. So every file that reads `config.lib.stylix.colors` can read
`config.desktop.colors` instead and render **byte-identical output**. The two differ only in
form: stylix yields `181616`, the palette yields `#181616`.

That is what makes Step 1 free, and it is the only reason this project is tractable in small
commits rather than one re-theme.

**Colour is the easy half.** What stylix also supplies — and what has to be written by hand —
is the per-program theming behind its target list: `bat`, `gtk`, `hyprlock`, `lazygit`,
`mako`, `qt`, `tmux`, `yazi`, `zathura`, plus `cursor`, `icons` and the font set.

---

## What each regime covers today

The two aspects are not two implementations of one thing. They cover *different sets*, which
is why the merge is not symmetric.

| Concern | `stylix` (gpc, UM790pro) | `palette` (swift5) |
| --- | --- | --- |
| colours to consumers | `lib.stylix.colors` | `desktop.colors` |
| fonts | `stylix.fonts` + 6 packages | 4 packages, no font config |
| cursor | Adwaita 24 | DMZ-Black 24 |
| icons | Papirus | — |
| gtk / qt | stylix targets | written by hand |
| bat, lazygit, tmux, yazi, zathura, hyprlock | stylix targets | **unthemed** |
| mako | stylix target | written by hand |

Two consequences worth stating before touching anything:

- **swift5 gains theming it does not have today.** bat, lazygit, tmux and yazi are `apps`, so
  swift5 has none of them; zathura is `core`, so swift5 has it unthemed. Folding into `core`
  themes it.
- **The cursor differs between regimes.** Unifying picks one. That is a visible change on two
  machines or one, and is the only step here that is a decision rather than a translation.

---

## Progress

Update this list in the commit that completes each step.

- [x] **Step 1** — colour readers move to `desktop.colors`; every stylix `aspectRequires` dissolves
- [x] **Step 2** — fonts to `core`
- [ ] **Step 3** — cursor and icons to `core` *(the one decision — see below)*
- [ ] **Step 4** — gtk and qt to `core`
- [ ] **Step 5** — mako drops its stylix branch; `palette` is now empty and leaves swift5
- [ ] **Step 6** — bat, lazygit, tmux, yazi, zathura, hyprlock themed from the palette
- [ ] **Step 7** — delete stylix: the module, the input, the aspect, the host entries

---

## Ground rules

`CLAUDE.md` §9, §10 and §13 apply in full. Specific to this project:

- **Step 1 is expected to be byte-identical on all six targets**, and that is the whole point
  of doing it first: it proves the palette substitution is sound before anything depends on
  it. A diff in Step 1 means the measurement above was wrong — stop and re-measure rather
  than accepting it.
- **Every later step is expected to change gpc and UM790pro**, because they stop being themed
  by a generator and start being themed by this repo. `verify.sh` explains those diffs; it
  does not demand zero. Inspect the generated file each step names.
- **swift5 is a control for Step 1 only.** It is tempting to treat it as one throughout, but
  Steps 2–5 move `palette` contributions into `core`, and `palette` is *last* in swift5's list
  while `core` is second — §5 says within-aspect rank reaches `home.packages` order, so swift5
  moves at every one of those steps. A control that is expected to move is not a control.
- **One program per commit in Step 6.** Six programs, six commits, each one a file you can
  read the generated output of. Do not batch them — a wrong colour in a batch is a bisect
  through a re-theme.
- **Do not touch `flake.lock` until Step 7**, and then only to drop the input. `nix flake
  update` is still forbidden (§6).
- **The palette is base24 and stylix is base16.** `base10`–`base17` have no stylix equivalent,
  so anything written by hand may use them, but nothing translated from stylix should need to.

---

## Step 1 — colour readers move to `desktop.colors`

Eight files read `config.lib.stylix.colors`. All eight prepend `#` themselves, because stylix
yields bare hex; `desktop.colors` already carries it.

- `discord.nix`, `hyprland-core.nix`, `opencode-style.nix`, `tmux.nix`, `walker.nix`,
  `_walker/style.nix`, `waybar-style.nix`, `wleave.nix`.
- Each binds the stripped palette once and the interpolations are left alone:

  ```nix
  c = lib.mapAttrs (_: lib.removePrefix "#") config.desktop.colors;
  ```

  This follows the existing precedent that consumers convert — `foot.nix` has `strip`,
  `dwl.nix` has `toBar` — rather than adding a second palette option in a second format.
- **Every `aspectRequires.<a> = ["stylix"]` goes**, in the same commit. Seven files carry one, under four distinct keys (`apps`, `hyprland`, `waybar`, `wleave`);
  after this step nothing reads another aspect's options for colour, because the palette is
  in `core` and `core` is universal.

**Measured:** all six targets byte-identical, which is the result this step exists to
produce. Every consumer of stylix's colours now reads the palette and renders exactly what it
rendered before, so nothing later in this plan has to argue about whether the two agree.

`_walker/style.nix` took the substitution at its signature — it is a plain function, not a
module, so it now takes `{colors}` rather than reaching into a `config` it was handed only
for colours. Better shape: it needs a palette, not a configuration.

`desktop.colors` is now typed `strMatching "#[0-9a-fA-F]{6}"`. The leading `#` became
load-bearing in nine files the moment they started stripping it, and a value defined without
one would have been silently right in eight of them and silently wrong in `mako.nix`, which
pastes it raw. Steps 5 and 6 add more consumers, so the type is worth more than the comment
that used to carry the rule.

**The dependency graph is now flat.** Seven files declared `aspectRequires.<a> = ["stylix"]`;
none do. Nothing in the tree reads another aspect's options for colour, because the palette
lives in `core` and every host takes `core`. The only requirement left is
`aspectRequires.waybar = ["hyprland"]`, which is about Hyprland's IPC, not theming.

## Step 2 — fonts to `core`

`font.nix` already declares `desktop.font` in `core` and installs different package sets per
regime. Unify the **packages** into `core`, as their union — which fonts a machine has is not
a theming decision, and a missing glyph is a missing glyph under either palette.

**`stylix.fonts` stays, deliberately, and goes at Step 7.** Deleting it here would have been
the obvious reading of "unify fonts", and it would have regressed the desktops: stylix still
themes gtk, qt, mako and hyprlock, and those targets read `stylix.fonts` for their font names.
Removing it while they are still enabled falls back to stylix's own defaults until Step 4
moves gtk and qt out. The same trap applies to `stylix.icons` — see Step 3.

**Measured:** swift5 gains `font-awesome` and `nerd-fonts-symbols-only`; UM790pro gains
`dejavu-fonts`. Nothing else moved in either closure, and no other generated file changed.

**The desktops had no home-manager fontconfig at all.** `fonts.fontconfig.enable` was set
only under `palette`, so `.config/fontconfig/` appears on UM790pro for the first time in this
step — it is *new*, not modified. stylix never enabled it, which means the profile's font
directories were reaching fontconfig by whatever the system provided rather than by anything
this repo said. Making the two hosts agree is the point of the project, so this is the change
working; note it because it is the sort of diff that reads as an accident.

## Step 3 — cursor and icons to `core`

`cursor.nix` is `palette`-only and already declares `desktop.cursor` with sane options.
Move it to `core` and delete `stylix.cursor`.

**This is the one step that is a decision, not a translation.** The two regimes disagree:
swift5 is DMZ-Black, the desktops are Adwaita, both 24px. `desktop.cursor`'s *defaults* are
DMZ-Black/`vanilla-dmz`, declared in `cursor.nix` — so moving that file to `core` unchanged
would elect DMZ-Black fleet-wide by accident. **Set the default explicitly in the same
commit**, so the choice is argued rather than inherited. One cursor package leaving the
closure is then the expected diff, not a mistake.

Icons are a **dedupe, not a gain**: `gtk.nix:13-16` already sets `Papirus-Dark` from
`palette`, so swift5 has it. What has no palette equivalent is stylix's
`icons.light = "Papirus-Light"`, and nothing here uses a light theme.

## Step 4 — gtk and qt to `core`

`gtk.nix` (both classes) and `qt.nix` are `palette`-only and hand-written already. Move both
to `core`, drop `stylix.targets.gtk` and `.qt`, and carry over the pieces `stylix.nix` sets
directly: `dconf` `color-scheme = "prefer-dark"` and the gtk3/gtk4
`gtk-application-prefer-dark-theme`.

## Step 5 — mako drops its stylix branch, and `palette` leaves swift5

`mako.nix` already writes colours under `palette` and geometry under `stylix`. Colours move to
`core`; the geometry block is about panel size, not theming, so decide whether it is a
`laptop`-vs-desktop distinction or belongs with the monitor record.

**This step empties the `palette` aspect, so it must also remove it from swift5's list.**
Steps 2–5 move every `palette` file into `core` — `font.nix` (2), `cursor.nix` (3),
`gtk.nix` both classes and `qt.nix` (4), `mako.nix` (5). An aspect name with no definitions
left is not inert: the generator's `unknownAspects` check throws
`hosts.swift5: unknown aspect palette`. Deferring the host edit to Step 7 would leave Step 5
unbuildable. Confirm before committing it:

```
nix repl → :lf . → config.flake.modules.homeManager ? palette
```

## Step 6 — the six programs stylix themed and nothing else does

`bat`, `lazygit`, `tmux`, `yazi`, `zathura`, `hyprlock`. One commit each. For each: read what
stylix generated **before** deleting the target, write the equivalent from `desktop.colors`,
then diff the generated file against the stylix output. The old output is the specification:

```bash
old=$(nix build --no-link --print-out-paths \
      "../dotfiles-prev#homeConfigurations.\"marcus@UM790pro\".activationPackage")
cat $old/home-files/.config/bat/config          # or the relevant path
```

`tmux` and `yazi` already have hand-written style files (`tmux.nix` reads colours directly,
`_yazi/style.nix` exists), so those two are closer to done than the list suggests.

**`hyprlock` may be a near-no-op, or may not be** — read before writing. `hyprlock.nix:53-55`
applies `lib.mkForce` to `background`, `label` and `input-field`, so whatever stylix
contributes to those three is already discarded on gpc and UM790pro. Whether anything of its
target survives elsewhere (`general`, colour strings) is *not* measured. `cat` the generated
`hyprlock.conf` before deleting the target; that file is the specification.

## Step 7 — delete stylix

- `modules/stylix.nix` goes.
- The `stylix` input goes from `flake.nix`; `nix flake lock` to drop it. Nothing else moves.
- `cachix.nix`'s `danth.cachix.org` is stylix's binary cache — it goes with it, which empties
  `nixos.stylix` and the file.
- `stylix` and `palette` leave all three host lists. Aspect count falls from thirteen to
  eleven.
- `README.md`'s aspect table and `CLAUDE.md` §9's "Stylix themes what it detects" hazard both
  describe a dependency that no longer exists. §9's hazard is replaced by its successor:
  nothing themes a program unless a file in this repo says so, which is the property this
  project buys.

**Expect:** the closure loses stylix and its base16-schemes dependency on gpc and UM790pro.
That is the measurement that says the project is done.

---

## Not now

- **Quickshell.** Waybar and walker stay.
- **A dwl host taking `waybar` or `walker`.** Four blockers, recorded in the roles plan in git
  history. Unchanged by this project.
- **dwl's conditional bar patch.** Same.
- **Darwin.** `systems` stays `["x86_64-linux"]`; `CLAUDE.md` §12 item 7 records it. Note that
  hand-written theming is *better* for a Mac than stylix was, since none of it depends on an
  input that has to support darwin.

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
- [x] **Step 3** — cursor to `core`, DMZ-Black fleet-wide. Icons deferred to Step 4
- [x] **Step 4** — gtk and qt to `core`, taking the icon theme with them
- [x] **Step 5** — mako drops its stylix branch; `palette` is now empty and leaves swift5
- [x] **Step 6** — all six programs off stylix; yazi's UI went with the target in Step 7
- [x] **Step 7** — stylix deleted: the module, the input, the cache, the aspect, the host entries

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

**Decided: DMZ-Black, fleet-wide.** It is the one a file in this repo chose; Adwaita arrived
with the generator being removed. `stylix.cursor` goes, and with it the
`home.pointerCursor.enable` workaround that existed only because the pinned stylix tripped a
home-manager deprecation.

**Icons moved to Step 4.** They are a dedupe rather than a gain — `gtk.nix` already sets
`Papirus-Dark` from `palette` — but deleting `stylix.icons` here would strip the desktops'
icon theme until `gtk.nix` reaches `core`, the same trap Step 2 hit with `stylix.fonts`.
Icons belong with the gtk move.

**Measured:** swift5 **byte-identical**, UM790pro gains `vanilla-dmz` and substitutes
Adwaita → DMZ-Black in every consumer at once — `gtk-3.0/settings.ini`, `gtk-4.0`,
`.gtkrc-2.0`, `uwsm/env`'s `XCURSOR_THEME`, and the `.icons` / `.local/share/icons` trees.
`gtk-icon-theme-name=Papirus-Dark` is untouched, confirming the icon deferral was the right
call.

That swift5 did not move contradicts the ground rule above, which predicted it would move at
every step from 2 to 5. The rule is right about *why* — within-aspect rank does reach
`home.packages` — but `cursor.nix` contributes no package of its own, so changing its aspect
moved nothing. Same lesson the roles plan learned twice: a file changing aspect only moves
store paths when that file itself lists a package.

## Step 4 — gtk and qt to `core`

`gtk.nix` (both classes) and `qt.nix` are `palette`-only and hand-written already. Move both
to `core`, drop `stylix.targets.gtk`, `.qt` and `icons`, and delete `stylix.nix`'s own `dconf`
and `gtk` blocks — `gtk.nix` carries the same settings.

**GTK keeps its palette; Qt does not.** Reading stylix's generated `gtk.css` before deleting
the target — which is the recipe this plan prescribes — showed 89 lines of nothing but
`@define-color` mappings from base00–base0F. That is precisely "apps pull from the colour
palette", so it is written by hand in `gtk.nix` from `desktop.colors` rather than lost.
**swift5 gains it**: it had `Adwaita-dark` with no palette colours at all, and now has both.

Qt is the opposite case and the one real loss. stylix drove it through Kvantum with a
generated `Base16Kvantum` theme (an SVG plus a `.kvconfig`), which is not reproducible by
hand at sane cost. Qt falls back to `adwaita-dark` via `qt.platformTheme` — what swift5 has
had all along. Qt apps on the desktops will look different: standard dark rather than
kanagawa-tinted. Accepted; revisit only if a Qt app actually looks wrong.

**Two deliberate departures from stylix's output**, both corrections rather than translation
errors, and stated here because everything else in this project claims to be a translation:

- `warning_color` was base0E (purple). It is base0A (yellow) now. A purple warning was a
  quirk of stylix's base16 mapping, not a decision anyone made.
- `dark_1`–`dark_5` were all base05 — `#c5c9c5`, a *light* grey, under names libadwaita hands
  to apps wanting dark shades. They are base01/base00 now.

**Measured:** swift5 gains `gtk.css` in both toolkit versions and nothing else — no closure
change beyond the two new files. UM790pro loses Kvantum, qt5ct and qt6ct along with their
Qt5 tooling (about 30 MiB), gains `gnome-themes-extra`, `adwaita-qt` and `gtk+`, and its
`settings.ini` moves `gtk-theme-name` adw-gtk3 → Adwaita-dark and `gtk-font-name` Inter 12 →
Inter 11. The font size is `gtk.nix`'s own long-standing choice, not a new one.

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

**Measured.** Reading the old output before deleting the target paid for itself again: stylix
generated `[urgency=critical]` and `[urgency=low]` sections and a `progress-color`, none of
which the palette branch had. Urgency is the one thing a notification daemon must show at a
glance, so those are written by hand and **swift5 gains them** — it never had urgency colours
at all. What is left of the desktop diff is two lines: `#181616FF` → `#181616`, the same
colour without a redundant alpha, and the font.

**The font changed on the desktops and is the one thing to look at.** stylix used its
sans-serif at a fixed size (`Inter 10`); `core` uses `desktop.font`, which is
`IosevkaTerm Nerd Font Mono` at the host's `fontSize` — 20 on the desktops, 16 on swift5. It
is self-consistent (the same relationship swift5 has had all along) but 20pt notifications are
noticeably larger than 10pt. If that reads badly, the fix is a notification-specific size in
`mako.nix`, not a change to `desktop.font`.

Two files, one aspect, one attrset: `mako.nix` now declares `homeManager.core` **once with
two elements**, not twice. Nix rejects a duplicated attribute path in a single literal — this
is not the `repeated_keys` style question §13 argues about, it is an eval error.

`palette` also leaves `README.md`'s aspect table and host lists, and `CLAUDE.md`'s §2 `font.nix`
exemplar, which was built entirely on the split. `mako.nix` was §2's "same daemon under two
theming regimes" example and is no longer that; `thunar.nix` takes its place.

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

**Measured, five of six done.** Reading the generated file first was the right rule every
time, and it changed the answer three times out of five:

| Program | Outcome |
| --- | --- |
| `zathura` | 20 settings written by hand; **swift5 gains all of them**, it had none |
| `bat` | first tried ANSI, which was **wrong**; now shares yazi's tmTheme — see below |
| `lazygit` | eight colours, generated `config.yml` **byte-identical** |
| `tmux` | one sourced file, but **four settings were surviving it** |
| `hyprlock` | the target was **already dead**; removing it changed nothing |

- **bat's ANSI shortcut was wrong, and the palette is why.** The first attempt replaced
  stylix's `base16-stylix.tmTheme` with bat's built-in `base16`, on the argument that it
  renders through ANSI 0–15 and `foot.nix` sets those from `desktop.colors` — no generated
  file, and it follows the palette for free. Correct as far as it goes, and it does not go far
  enough: **base16 and base24 disagree about what the bright slots hold.** base16's convention
  puts base09 in ANSI 9; `foot.nix` maps `bright1` to base12, because that is what base24 says
  bright red is. Rendering a `.nix` file through `--theme=base16` shows it — `42` comes out as
  `38;5;9`, which foot paints `#e46876` bright red, where the theme means base09 `#b6927b`.
  Plain text is off too: `37` is `regular7`, which foot maps to base06, not base05.

  So bat now reads the same tmTheme yazi's preview does. The rule this teaches is narrower
  than "prefer ANSI": **ANSI is only free when the palette's own terminal mapping agrees with
  the theme's convention**, and a base24 palette driving a base16 theme does not. Programs
  that name their own colours (tmux, zathura, lazygit) are unaffected; it is only the ones
  that ask for "the base16 theme" that inherit the disagreement.
- **tmux was the near-miss.** Its target contributed one `source-file` line, and `tmux.nix`'s
  own `extraConfig` overrides most of what that file sets — so "redundant" was the obvious
  conclusion. Reading it showed four settings nothing else touched: the prefix+q pane
  numbers, and the bell and activity styles. Assuming would have deleted them silently.
- **hyprlock runs on its own defaults.** `hyprlock.nix` mkForces every list stylix
  contributes to, so the generated conf has had no colours in it for as long as those forces
  have existed. Giving the lock screen palette colours is a real visual change and is
  deliberately *not* smuggled into a commit about removing a dependency.

**yazi is what is left, and it splits into three pieces that are not equally hard.**

Measured against yazi 26.5.6's compiled-in preset theme, extracted from the binary:

- **The UI is ANSI, not hex.** The preset's `mgr`, `mode`, `pick`, `input`, `tasks`, `help`,
  `cmp`, `status` and `filetype` sections contain **zero** hex values — every colour is a name
  (`blue`, `gray`, `reversed`), so they resolve through foot's sixteen, which already come
  from `desktop.colors`.

  **This is not the argument that failed for bat**, and the difference is the whole reason it
  still stands. bat's `base16` theme means *base09* and spells it "ANSI 9", so it breaks the
  moment a base24 palette puts base12 there. Yazi's preset means *blue* and spells it "blue" —
  it asserts nothing about which base slot that is, so whatever foot calls blue is the right
  answer by construction. A theme naming terminal colours is safe; a theme naming palette
  slots through terminal colours is not.

  Partial themes deep-merge onto the preset: a
  27-character `theme.toml` loads clean, and `fg = "notacolour"` is a parse error, so the
  acceptance is real and not silent ignoring. Deleting the empty UI stubs is therefore
  *removal*, not porting. The preset's `filetype` rules are also richer than stylix's — orphan,
  exec and dummy entries that stylix omits.
- **The icon table is a stale copy of yazi's own.** 669 rules in `_yazi/style.nix` against 725
  in the preset; 636 byte-identical, **zero** unique to us, 56 missing. The 33 that differ are
  14 `dirs` and 11 `conds` with `fg` stripped, plus 8 colours from an older devicons vintage
  (`go` `#519aba` vs upstream `#00add8`). Shelved: the `icons-brew` plugin is the intended
  replacement, so this waits for that decision rather than being solved here.
- **`syntect_theme` is the only part with no ANSI fallback** — done, see below.

**Stylix writes a `[completion]` table that does not exist in yazi 26.5.6.** The section was
renamed `[cmp]`; stylix emits both. Not an argument that decides anything, but it is the
complaint that motivated this plan, appearing in this repo's own generated output.

### Measured — the syntect theme

`modules/tmtheme.nix` renders the base16 tmTheme (bat's template, which is what stylix was
using) through `lib.generators.toPlist` from `config.desktop.colors`. 44 scope rules and 8
global keys as a Nix data table, ~110 lines instead of 540 of XML.

**It is `desktop.syntaxTheme` in `core`, read by two files.** It started as
`_yazi/tmTheme.nix` and moved out the moment bat needed it too — a path under `_yazi/` would
have said the theme belongs to yazi, and it belongs to syntect. Same shape as
`launcher.command` and `fileManager.command`: an option namespace in `core`, one setter, and
consumers that name it. `_yazi/style.nix` reads it for `mgr.syntect_theme`, `bat.nix` reads it
for `programs.bat.themes`. Declaring it in `core` cost swift5 nothing — it takes neither
consumer, so nothing references the derivation and its closure is unchanged.

- **Semantically identical to what stylix generated.** Both files normalise to 44 rules with
  the same scope→colour mapping and the same 8-key global dict; only metadata and plist key
  order differ. The generated `theme.toml` changes by exactly one line, the path.
- **Verified it parses, not just that it builds.** Built bat's cache from the generated
  `.config/bat` and rendered a `.nix` file through it: every colour emitted is a palette slot —
  base03 comments, base0B strings, base0E keywords, base09 constants, base05 text. That is
  also the check that caught the ANSI mistake above, by rendering the same file both ways.
- **`syntect_theme` needs `mkForce` until Step 7**, because stylix's yazi target still sets
  it. The force comes out with the target, exactly as lazygit's did.
- swift5 byte-identical; gpc and UM790pro swap one tmTheme for another in the closure.

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

### Measured — done

**Step 7 turned out to be the yazi UI step as well.** Deleting `stylix.nix` removed
`yazi.enable`, and the UI sections `_yazi/style.nix` had been leaving empty then merged onto
yazi's preset. Nothing was ported; the stubs were deleted and the preset showed through. The
generated `theme.toml` fell from 3786 lines to 3412, and every section that changed was a
*removal* — the diff has no added lines at all. `[completion]`, the table stylix emitted that
yazi 26.5.6 does not have, went with it.

- **swift5 byte-identical, empty closure diff.** It never carried stylix, and nothing it takes
  moved.
- **gpc and UM790pro:** `~/.config/stylix` and the generated `base16-kanagawa-dragon.{html,json}`
  are gone from the closure; `nix.conf` loses the `danth.cachix.org` substituter. That is the
  whole of the system-side change.
- **`flake.lock` lost the input and its eleven transitive pins, and moved nothing else.** The
  diff is 280 deletions against one insertion, and the insertion is a `systems_4` → `systems_3`
  renumbering.
- **The aspect count fell from thirteen to twelve, not eleven.** The plan predicted `stylix`
  and `palette` leaving together; `palette` had already gone at Step 5, so Step 7 removed one.

Prose that named stylix was corrected in the same pass, and correcting it surfaced drift that
predated this project: §2's exemplar counts were stale from the roles refactor (16 files → 18,
and `font`, `launcher` and `clipboard` have each dropped to one aspect), §3 still called
`launcher.nix` "three memberships", and §4's `font/` directory example describes a directory
that has never existed. The counts are now derived rather than remembered, and the statix list
in §13 was re-run rather than trusted — it flags eight files now, not nine, and one of them
(`gtk`) for an unrelated repeated key.

**Expect:** the closure loses stylix and its base16-schemes dependency on gpc and UM790pro.
That is the measurement that says the project is done.

**Correction: the line counts above understate what that commit contains.** The icon table was
deleted from `_yazi/style.nix` while the commit was being assembled, and `git add -A` swept it
in. So `theme.toml` fell 3786 → **89**, not 3412, and `f9a7f32` is the icon commit as well as
the stylix commit. The claim that the diff has no added lines still holds.

---

## After — yazi minimised

Not a step of this plan; a consequence of it. With stylix gone there was nothing left in
`_yazi/` that yazi's own preset did not already say, so both files went and what survives is
inlined in `modules/yazi.nix`. 498 lines across three files → 204 in one.

**Most of what was deleted had never done anything.** `_yazi/yazi.nix` was `{settings = {…};}`
and `yazi.nix` assigned it to `programs.yazi.settings`, so every key landed a level too deep —
`yazi.toml` was 354 lines of `[settings.mgr]`, `[settings.preview]`, `[settings.tasks]`, none
of which yazi reads. It was also a verbatim copy of yazi's defaults under the pre-26 section
name (`manager`, not `mgr`), so even at the right depth it would have been a no-op. The one
line that was *not* inert-by-redundancy went with it: `plugin.prepend_fetchers` registers the
git plugin's status column, and nested under `[settings]` it never registered. **Deleting the
file turned the git column on for the first time.** `yazi.toml` is now nine lines and all nine
are load-bearing.

**The preset names colours correctly and composes them badly, and those are different
claims.** Step 6 established the first — the UI is ANSI, so foot's palette decides — and it
still holds. What it does not cover is contrast, because a name says nothing about what it is
put next to. Three of the four overrides are that:

- `mode.normal_main` is preset `bg = "blue"` with no `fg`, so base05 text sits on base0D. Both
  are light; the mode indicator was the least readable thing on screen. `normal_alt` is
  `fg = "blue", bg = "gray"` — base0D on base06, worse.
- `status.progress_normal` and `progress_error` paint on solid `black` and `red` blocks, which
  under this palette is base11 and base08 — two panels that are not the background behind them.
- `mgr.border_style` is `gray`, ANSI 7, which `foot.nix` maps to base06 — a border brighter
  than the text it frames. base0D instead, matching tmux's active pane border. The popup
  frames (`confirm`, `cmp`, `input`, `pick`, `spot`, `tasks`) follow it so the frames read as
  one surface.

The status line is written in tmux's vocabulary deliberately: transparent behind everything,
one reversed chip, colour carried by the foreground. `tmux.nix`'s `status-left` is
`fg=thm_bg,bg=thm_blue,bold`, and `mode.normal_main` is now the same three values.

**`bg = "reset"`, not an omitted key.** A partial `theme.toml` merges onto the preset, so a
background is only cleared by naming one; `reset` is the preset's own spelling for the
terminal default (`mgr.find_position` uses it). Every inline table this file touches is
restated in full for the same reason — that makes the result independent of how deep yazi's
merge goes, which is the one thing about it that is not measured here.

**The fourth override is not a colour.** `indicator.preview` is preset `underline = true`, and
an underline crosses the descenders of the filenames it marks. `bg = base02` carries the same
"last hovered here" information and leaves the glyphs alone, and it puts the preview pane a
step below the two `reversed = true` panes rather than level with them in a different idiom.

**Directory icons were the one place the preset is hex, not ANSI.** `icon.dirs` is 14
named-folder rules at `#ff9800`/`#00bcd4`/`#03a9f4`, and `icon.conds` colours the fallbacks at
`#03a9f4`. A rule with no `fg` takes the file's own colour, and `filetype` rules are ANSI
names, so dropping `fg` is what hands directories back to the palette. `dirs = []` removes the
14; `conds` is restated as its 12 rules minus the colours, because a list is replaced rather
than merged. The glyphs are unchanged — the ask was terminal colours, not different icons.
Files keep the devicon hex in `icon.files` and `icon.exts`, which is what the shelved
`icons-brew` decision is about.

### Measured

- **All six targets build; swift5 byte-identical with an empty closure diff.** It does not take
  `apps`, which is the containment check.
- **The theme parses, and the check that says so bites.** `yazi --debug` reads and validates
  `theme.toml`; appending `fg = "notacolour"` makes it a hard startup error at that line, and
  the file as generated loads clean. So `underline = false`, `bg = "reset"` and `dirs = []` all
  deserialise rather than being ignored.
- **Section-level merge confirmed at runtime, not assumed.** A Lua probe in `init.lua` reads
  `th.mgr.cwd`, which this file never sets — a partial `[mgr]` does not wipe the preset's other
  keys. `th.icon` is not exposed to Lua, so the `dirs = []` replacement is documented behaviour
  and prior measurement, not re-measured here.
- **gpc and UM790pro lose three plugins from the closure** — `full-border`, `lazygit`,
  `smart-enter` — and nothing else. `full-border` leaving is why `border_style` now shows on
  the plain `│` divider.

---

## Not now

- **Quickshell.** Waybar and walker stay.
- **A dwl host taking `waybar` or `walker`.** Four blockers, recorded in the roles plan in git
  history. Unchanged by this project.
- **dwl's conditional bar patch.** Same.
- **Darwin.** `systems` stays `["x86_64-linux"]`; `CLAUDE.md` §12 item 7 records it. Note that
  hand-written theming is *better* for a Mac than stylix was, since none of it depends on an
  input that has to support darwin.

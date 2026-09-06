# Firefox

<a id="main-thread-autoscroll"></a>
## `firefox.nix` — autoscroll runs on the main thread

**Why** Middle-click autoscroll has two modes with two code paths: held-drag
scrolls from the main thread, while click-release ("sticky") autoscroll rides
the APZ compositor path, which accelerates markedly faster for the same cursor
offset (Bugzilla 1386742 is this asymmetry). No pref scales autoscroll
sensitivity — the smoothScroll cluster below does not touch it — so the only
lever is `apz.autoscroll.enabled = false`, which routes both modes through the
main-thread profile the held-drag mode already exhibits.
**Breaks** Autoscroll animation is no longer asynchronous: a busy main thread
(heavy page JS) can stutter the scroll where APZ would have stayed smooth.
Accepted as the lesser evil; delete the pref if the trade reverses, and
re-test on a pin bump — a fixed APZ speed curve upstream makes this pref pure
downside.

<a id="userchrome-important"></a>
## `firefox/style.nix` — every declaration carries `!important`

**Why** `userChrome.css` is a *user*-origin sheet while Firefox's own chrome
CSS is *author*-origin, and author beats user for normal declarations. A
user-origin `!important` is the only thing that outranks author-important, so
it is not emphasis here — it is the whole mechanism. The route the theme API
intends, `--lwt-*`, is inert without an installed theme: those variables apply
only under `:root[lwtheme]`, and stable Firefox enforces addon signing, so a
locally built theme XPI cannot supply one.
**Breaks** *Silently.* The sheet loads, every rule parses, and not one colour
changes.

<a id="chrome-font"></a>
## `firefox/style.nix` — the chrome font takes a family but no size

**Why** The family is pinned so the browser stops inheriting it implicitly, and
it reads `gtk.font.name` rather than a fourth literal `Inter` — `theme/qt.nix`
already reads `gtk.font` for this same "desktop UI font" meaning. The size is
deliberately absent: Firefox scales its chrome from the GTK font size, which is
that same source, so pinning a `pt` in the sheet would fight
`browser.uidensity = 1` rather than agree with it.
**Breaks** A pinned size shows up as clipped tab labels at compact density, not
as a parse error.

<a id="content-backgrounds"></a>
## `firefox/style.nix` — namespaced tokens run loose, generic ones are fenced

**Why** `userContent.css` reaches every page, so the split is by how ownable
the name is. `--newtab-*` cannot collide with a site, and running it unfenced
is what makes it independent of the URL the new tab page is served from — it is
a built-in extension whose document lives under `resource://newtab/`, and
whether the sheet sees that or `about:newtab` is a property of the redirect.
`--text-color` and `--background-color-canvas` are generic enough for a site to
own, so those stay behind `@-moz-document`.
**Breaks** *Silently.* Fencing the newtab tokens on the wrong URL leaves the
page on Firefox's own `#2B2A33`.
**Also** the blank background between page loads is deliberately not themed.
Its only lever, `browser.display.background_color`, is inert unless
`browser.display.document_color_use = 2` — measured — and that overrides every
site's own colours.

<a id="extension-managed-storage"></a>
## `firefox.nix` — extension configuration goes through `3rdparty`, not `ExtensionSettings`

**Why** An `ExtensionSettings` entry takes only the keys Firefox's
`policies-schema.json` names, and it names two overlapping sets neither of which
contains the other: twelve for a named extension, ten for the `*` wildcard.
Anything outside them is dropped — `additionalProperties` is unset and Firefox
ignores what it does not know — so a `settings = { … }` sub-attribute configures
nothing. What reaches an extension is `3rdparty.Extensions.<id>`, handed to
`storage.managed` verbatim. Use `adminSettings`, not its sibling `toOverwrite`:
the latter's `filterLists` *wins* and replaces the selection wholesale, so it
could not be split across files the way this one is. `"user-filters"` leads the
list because uBO gates `userFilters` on that token being selected, so dropping
it stores the custom filters and never applies them.
**Breaks** *Silently, in three different ways.* The wrong key writes valid JSON
that no one reads; the wrong nesting reaches an extension that discards it; the
missing token leaves a populated filter pane switched off. Nothing warns —
`about:policies#errors` stays empty for all three. Only the extension's own
dashboard shows the truth.
**Also** SponsorBlock reads no managed storage at all, so its segment map has
no declarative home and lives in its options page.

<a id="ubo-imported-lists"></a>
## `firefox/youtube.nix` — a subscribed list URL needs `importedLists`, not just selecting

**Why** `restoreAdminSettings` copies `adminSettings.selectedFilterLists` into
storage, but nothing there registers an asset source. Only
`userSettings.importedLists` does that: `getAvailableLists` turns each URL in it
into a registered `user`-submitted asset, then walks every such asset and
deletes from the selection any it did not just register. A URL selected but not
imported is therefore removed on the first run, not merely left unfetched.
`externalLists` is uBO's own deprecated mirror of the same list, regenerated
from it on save, so setting one of the pair is enough.
**Breaks** *Silently.* uBO starts, the stock lists load, and the subscribed list
is simply absent from the filter pane — no error, nothing in
`about:policies#errors`.
**Also** two consequences of this being a policy rather than a setting.
`restoreAdminSettings` runs on every launch and rewrites *My filters* whenever
it differs, so a filter added by hand in the dashboard does not survive a
restart — the Nix file is the only place to add one. And `vAPI.adminStorage`
answers from a cached copy and refreshes it afterwards, so a changed policy
lands on the *second* launch after the switch, not the first.

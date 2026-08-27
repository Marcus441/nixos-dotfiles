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

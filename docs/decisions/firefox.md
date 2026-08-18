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

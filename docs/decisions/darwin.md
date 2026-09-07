# Darwin

What the Mac does differently from the Linux hosts, and what it must not.

<a id="homebrew-cleanup"></a>
## `homebrew.nix` — `onActivation.cleanup = "zap"`

**Why** Homebrew is the only package source here that Nix does not own, so it
is the only one where a `brew install` by hand would outlive the declaration
that never mentioned it. `zap` makes a switch converge: every cask and App
Store app not declared in some `darwin` file is uninstalled, with its
preferences, so the Brewfile is the whole truth the way `home.packages` is.
**Breaks** *Silently, and outward.* A cask installed by hand for an
afternoon is gone at the next switch, without a prompt. Declare it, or expect
to lose it.

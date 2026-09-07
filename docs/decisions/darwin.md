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

<a id="kitty-listen-socket"></a>
## `terminal/kitty.nix` — `listen_on` is a path on macOS, abstract on Linux

**Why** `unix:@mykitty` names an abstract socket, a Linux-only namespace;
macOS has none, so kitty there needs a filesystem path, and `/tmp/mykitty` is
the one kitty's own docs give. kitty appends `-<pid>` to both forms, and the
smart-splits kittens read the resolved value from `KITTY_LISTEN_ON`, so the
form is invisible to them.
**Breaks** Loudly on the Mac: the socket is never bound, `allow_remote_control`
has nothing to answer on, and every `neighboring_window` call fails.
**Also** `macos_option_as_alt` is set there too, or the `alt+hjkl` resizes
type accented letters instead of resizing.

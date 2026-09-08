# Darwin

What the Mac does differently from the Linux hosts, and what it must not.

<a id="homebrew-cleanup"></a>
## `homebrew.nix` — activation never uninstalls; cleanup is a command

**Why** `brew bundle install --force-cleanup`, which is what every
`onActivation.cleanup` other than `none` runs, removes every kind of thing
Homebrew knows, and since Homebrew 4.7 that includes Mac App Store apps —
Apple's own, and Safari's extensions, which are App Store apps too. The
install path passes no type switches to its cleanup, so
`HOMEBREW_BUNDLE_CLEANUP_NO_MAS` cannot reach it. Measured on the first
switch: seven App Store apps installed by hand were uninstalled, and the two
Safari extension apps survived only because macOS refused the ownership
change. So activation only installs. Removing an undeclared cask or editor
extension is `brew bundle cleanup --force --zap`, by hand: `global.brewfile`
points it at the generated Brewfile, and the exported
`HOMEBREW_BUNDLE_CLEANUP_NO_MAS` keeps it off the App Store even then.
**Breaks** *Silently, the other way.* A cask installed for an afternoon stays
until someone runs the command; `darwin-rebuild` prints what it would remove
at check time and touches nothing.

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

<a id="vscode-settings-path"></a>
## `editor/vscode.nix` — `settings.json` is a `home.file`, at the path VS Code reads

**Why** VS Code keeps user settings under `~/Library/Application Support` on
macOS and under `$XDG_CONFIG_HOME` on Linux, so the file is placed by
platform, the way Home Manager's own `programs.vscode` places it. That module
is not used because it also installs the editor from nixpkgs, and the Mac
takes the cask, with extensions from the Brewfile rather than nixpkgs.
**Breaks** *Silently.* A file at the wrong path is a file VS Code never
opens: the defaults apply and no setting complains.
**Also** the file is read-only, so a tweak made in the settings UI fails to
save; it belongs in the workspace's `.vscode/settings.json` or here.

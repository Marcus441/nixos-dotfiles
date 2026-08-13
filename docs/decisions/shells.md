# Shells

Which shell a host logs into, and what the second one costs.

## `zsh` is an aspect, not part of `hyprland`

Only the two Hyprland hosts log into zsh, so keying it off the `hyprland` aspect
would have worked and been wrong: it would make *which shell I log into* a
property of the compositor, and swift5 could then only get zsh by taking
Hyprland. `zsh` is a decision, swift5 says no to it, and nothing in it reads a
host fact.

The coincidence with the Hyprland hosts is a fact about the host list, not a
structural coupling.

`bash.nix`'s old `hyprland` block is not a precedent for session-keyed *shell*
config — `sessions.md` records it as session startup wearing shell clothing, and
it now lives in `hyprland.nix`.

## None of it is `core`

`conventions/placement.md` asks whether a value *does* anything on a host that
ignores it. zsh configuration is not inert: it puts zsh, zsh-autosuggestions and
nix-zsh-completions into the closure of a host that never runs them. So swift5
carries no zsh at all, and stays the control that proves the rest of a shell
change moved nothing.

<a id="zsh-nixos-surface"></a>
## The NixOS surface is three lines, and each is load-bearing

- **`enable = true`** is not optional next to `users.users.<user>.shell`. There
  is no assertion tying them: set the shell alone and zsh starts with no
  `/etc/zshenv`, which is the file that sources `system.build.setEnvironment` —
  so no NixOS environment — and zsh is absent from `/etc/shells`, which
  `enable` is also what populates.
- **`promptInit = ""`** replaces a default of `autoload -U promptinit &&
  promptinit && prompt suse && setopt prompt_sp`, which runs in `/etc/zshrc`
  before `~/.zshrc` and installs a theme's own hooks under ours.
- **`enableGlobalCompInit = false`** because Home Manager runs `compinit` from
  `~/.zshrc`; the default would run a second one from `/etc/zshrc`.

`enableCompletion` stays on — it is what puts `/share/zsh` in `pathsToLink` and
`nix-zsh-completions` on the system.

`user.nix` declares a `loginShell` option defaulting to bash and reads it into
`users.users.<user>.shell`; the aspect sets it. `mkDefault` on the shell itself
does not work — nixpkgs' `users-groups.nix` already defines it at that priority,
so lowering ours produces a "defined multiple times" conflict rather than an
override. An option is also what the repo does when two implementations compete
for one slot, and here they are two shells.

<a id="zsh-dotdir"></a>
## `dotDir` is set, and history is pulled out of it

Home Manager warns that `dotDir`'s default flips to the XDG config directory at
`stateVersion` 26.05; setting it now adopts the new behaviour rather than
inheriting it at an upgrade nobody connects to the breakage.

**Why** `history.path` defaults to `${dotDir}/.zsh_history`, so moving `dotDir`
alone would file 100 000 lines of history under `~/.config`. History is state.
No `.keep` is needed beside it, unlike the two in `xdg-app-dirs.nix`: the
generated `.zshrc` runs its own `mkdir -p "$(dirname "$HISTFILE")"`.
**Breaks** Session startup, at first glance: `hyprland.nix` puts the uwsm start
in `programs.zsh.profileExtra`, which is now `~/.config/zsh/.zprofile`, a path
zsh reads only because Home Manager keeps a `~/.zshenv` stub that exports
`ZDOTDIR`. Deleting that stub as stray leaves no error and no session.
**Also** `sessions.md#uwsm-login-shell` for the other half of that path, and
`xdg.md#prefer-xdg-directories` for why this one is set by hand — `dotDir`
keys off `stateVersion`, not `home.preferXdgDirectories`.

<a id="zsh-keymap"></a>
## `defaultKeymap = "emacs"`, and the re-source that follows it

zsh picks `viins` when `VISUAL` or `EDITOR` contains `vi` — and `EDITOR` is
`nvim`, which does. Measured: `EDITOR=nvim zsh -f -i -c 'bindkey -lL main'`
prints `bindkey -A viins main`, and unsetting it prints `emacs`. bash's readline
is emacs, so mirroring it means saying so.

The cost is not obvious. `/etc/zshrc` sources `/etc/zinputrc`, which binds
Home, End, Insert, Delete and the page keys from terminfo into whatever keymap
`main` pointed at — `viins`. Home Manager's `bindkey -e` runs afterwards, from
`~/.zshrc`, and relinks `main` to `emacs`, stranding them. Measured: after
`bindkey -v; bindkey "\e[H" beginning-of-line; bindkey -e`, that sequence
reports `undefined-key`, and is still bound under `-M viins`.

So `initContent` re-sources `/etc/zinputrc` after the switch. The `-r` guard is
what keeps a home-manager aspect from asserting a NixOS path.
**Breaks** *Silently.* Tested by removing the line on the running system: Home,
End, Delete and both page keys all report `undefined-key`, with no error at
startup and no clue that a file was read into a keymap nothing points at any
more. It is not a no-op — do not drop it.

<a id="zsh-menu-select"></a>
## `menu select` is what makes the completion list legible

**Why** `list-colors` alone renders a plain list: no entry is current, so
nothing is highlighted and the arrow keys still belong to the command line.
`menu select` is what loads `zsh/complist` for a selectable menu, whose
`menuselect` keymap already binds the arrows. It is a departure from mirroring
bash — readline has no menu at all — and a deliberate one.
**Also** `_setup` loads `zsh/complist` on its own when `list-colors` is set, so
checking `zmodload -L` at startup says `NOT loaded` and means nothing: the
module arrives at the first completion, not at login.
**Also** The menu opens on the *second* tab. The first shows the list, and
`AUTO_MENU` starts menu completion on the next — which is when the
`menuselect` keymap takes the arrow keys. A single tab followed by an arrow
moves the cursor along the command line and looks like a dead menu.

## The menu's own colours, but not the file types'

**Why** Two different things are coloured and they answer to different owners.
The candidates are file names, coloured from `LS_COLORS` so that a listing and
an `ls` agree — replacing that with a palette-built database would desync the
two and duplicate dircolors. The menu's own furniture is ours: the selected row
takes `ma=` in `desktop.colorsRgb`, set to base02 on base06 so it reads as the
same selection the terminal gives, and the group headings, messages
and the no-matches warning take base0C, base03 and base08 through `%F{...}`.

`ma=` is why the third consumer of `desktop.colorsRgb` exists: `list-colors`
takes raw SGR parameters, not hex.

**Breaks** Nothing loudly. Verified under a pty instead: two tabs and a down
arrow emit `48;2;57;56;54;38;2;200;192;147` against `zinputrc` and then
`zoneinfo`, which is the selection moving.

## Syntax highlighting names every style, rather than taking the defaults

**Why** zsh-syntax-highlighting's defaults are ANSI names — `fg=red`,
`fg=green` — which under any of the four terminals already resolve to this
palette, because each maps `desktop.ansi` onto the terminal's sixteen. They stop
being ours the
moment the shell is reached from somewhere else, which is the same reason
`bat.nix` does not use its built-in base16 theme. So every style is set from
`colors16` as a 24-bit `fg=#rrggbb`, and the roles are five bindings in a `let`
rather than thirty literals: command, string, substitution, path, plain.

Home Manager sources the plugin at `mkOrder 1200`, after `initContent` at 1000,
which is the order the plugin needs — it wraps the widgets that exist when it is
sourced, so `edit-command-line` has to be defined first. Verified in the
generated `.zshrc`. zsh-autosuggestions is sourced earlier, at 700, and
re-binds on every `precmd`, so it wraps the wrapper rather than fighting it.

**Also** `fastSyntaxHighlighting` is the other option in the same module, and an
assertion forbids enabling both.

## `^X^E` needs saying; readline binds it for free

**Why** `bind -q edit-and-execute-command` reports `\C-x\C-e` in bash, and
`bindkey "^X^E"` reported `undefined-key` in zsh — the `edit-command-line`
widget ships with zsh but is neither autoloaded nor bound. Three lines in
`initContent` fix that, after the keymap switch so the binding lands in `emacs`.

**Also** The two are not identical. readline's runs the line on leaving the
editor; zle's replaces `$BUFFER` and hands it back, so it still wants Enter.
`edit-command-line` reads `$VISUAL` before `$EDITOR`, both `nvim` here, and its
`(*vim*)` branch passes `-c "normal! ${byteoffset}go"` so the cursor lands where
it was on the command line.

## What does not carry over

`programs.readline` stays bash-only: it renders `~/.inputrc`, which zle does not
read. `/etc/zinputrc` is an unrelated zsh script that happens to rhyme.

| bash | zsh |
| --- | --- |
| `completion-ignore-case`, `completion-map-case` | one `matcher-list` zstyle |
| `show-all-if-ambiguous` | `unsetopt list_ambiguous` |
| `mark-directories`, `mark-symlinked-directories` | already the default |
| `colored-stats` | `list-colors` zstyle, from `LS_COLORS` |
| `skip-completed-text` | **nothing** |
| `globstar` | **nothing needed** — recursive globbing is built in, spelled `**/*.c` |
| `extglob` | `extended_glob` — the same idea, not the same syntax; `?(…)` would want `ksh_glob` |
| `nullglob` | `null_glob` — the one that genuinely changes behaviour, zsh erroring by default |
| `dirspell` | **nothing.** `_approximate` was tried as the nearest thing and dropped — see below |
| `cdspell` | **nothing.** `correct`/`correct_all` prompt, and correct command words |

The completer list is `_complete _match` — real matches, then pattern matches
when the word carries a glob. `_approximate` sat on the end as the closest
thing zsh has to `dirspell`, and came off: it fires only once the first two
have found nothing, which is exactly when there is no good answer, so what it
adds to the menu is guesses. bash's `dirspell` corrects a path component
silently during completion and never offers alternatives; the two are not the
same trade, and one typo-tolerant completion is not worth a menu you have to
read twice. So `dirspell` and `cdspell` both map to nothing, deliberately.

## The prompt is one file, two implementations

`prompt.nix` holds both. zsh cannot reuse a line of the bash one — `%~` for
`\w`, `precmd` for `PROMPT_COMMAND`, `%F{#rrggbb}` for a hand-written SGR
sequence — so what must not drift is which palette slot means cwd, git, dev
environment, ok and error. That is a slot map in the file's outer `let`, and
both elements close over it.

`%F{#rrggbb}` rather than raw escapes in `%{…%}`: zle then computes the prompt
width itself, which is the whole of the classic zsh prompt-corruption bug.
Verified to emit the same sequence the bash half writes by hand —
`print -P "%F{#8ba4b0}"` gives `38;2;139;164;176`, which is
`colorsRgb.base0D`.

The sigil colour is `%(?.….…)`, so nothing has to capture `$?` as its first
statement the way the bash half must. Verified that a `precmd` hook running its
own commands does not clobber it.

## Both shells stay configured

bash remains swift5's login shell, stays installed and configured on the
Hyprland hosts, and keeps `~/.profile` — which `xsession-wrapper` sources for
every graphical session regardless of login shell. Histories are separate:
`~/.bash_history` and `~/.zsh_history`, so the suggestions start cold.

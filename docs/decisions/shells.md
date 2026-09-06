# Shells

Which shell a host logs into, and what the second one costs.

## `zsh` is an aspect, not part of `hyprland`

**Why** Only the two Hyprland hosts log into zsh, so keying it off `hyprland`
would have worked and been wrong — it makes *which shell I log into* a property
of the compositor, and swift5 could then only get zsh by taking Hyprland. The
coincidence is a fact about the host list, not a coupling.
**Also** none of it is `core`: zsh config is not inert, it puts zsh,
zsh-autosuggestions and nix-zsh-completions into the closure of a host that
never runs them. swift5 carries no zsh and stays the control that proves a shell
change moved nothing.

<a id="direnv-nix-json-for-neovim"></a>
## `dev/direnv.nix` — nix logs JSON when Neovim is the reader

**Why** Neovim's direnv integration draws its progress bar from nix's
`--log-format internal-json` stream, and that format is a flag with no
environment or `nix.conf` equivalent. nix-direnv calls nix through its `_nix`
wrapper, and direnv sources `direnvrc` after `lib/*.sh`, so redefining `_nix`
in `programs.direnv.stdlib` adds the flag without forking nix-direnv. It is
gated on `$NVIM` — set in every process Neovim spawns — and on stderr not being
a terminal, which keeps a `:terminal` inside Neovim, and every shell, on
direnv's ordinary output.
**Breaks** *Silently, in the editor.* The consumer is `modules/direnv.lua` in
`Marcus441/neovim.nix`; this flake pins that repository by revision, and with
a pin that predates it every `@nix {…}` line lands in the editor as text. Bump
the pin before switching this on. The override also restates nix-direnv's own
flags (`--no-warn-dirty`, `--extra-experimental-features`); a nix-direnv bump
that changes them changes nothing here.
**Also** `$_nix_direnv_nix` is set by nix-direnv's preflight before any `_nix`
call, so the override binds late and needs no nix path of its own. devenv is
untouched: it renders its own progress and drops it on a pipe.

<a id="zsh-nixos-surface"></a>
## The NixOS surface is three lines, and each is load-bearing

- **`enable = true`** is not optional next to `users.users.<user>.shell`, and no
  assertion ties them. Set the shell alone and zsh starts with no `/etc/zshenv`
  — the file that sources `system.build.setEnvironment`, so no NixOS environment
  — and is absent from `/etc/shells`, which `enable` also populates.
- **`promptInit = ""`** replaces a default that runs `prompt suse` in
  `/etc/zshrc`, before `~/.zshrc`, installing a theme's hooks under ours.
- **`enableGlobalCompInit = false`** because Home Manager runs `compinit` from
  `~/.zshrc`; the default would run a second from `/etc/zshrc`.

`enableCompletion` stays on — it is what puts `/share/zsh` in `pathsToLink`.
**Also** `user.nix` declares a `loginShell` option defaulting to bash; the
aspect sets it. `mkDefault` on the shell does not work — nixpkgs' `users-groups.nix`
already defines it at that priority, so lowering ours conflicts rather than
overriding.

<a id="zsh-dotdir"></a>
## `dotDir` is set, and history is pulled out of it

**Why** `dotDir`'s default flips to the XDG config directory at `stateVersion`
26.05; setting it now adopts that rather than inheriting it at an upgrade nobody
connects to the breakage. `history.path` defaults to `${dotDir}/.zsh_history`,
so moving `dotDir` alone would file 100 000 lines of history under `~/.config`.
History is state.
**Breaks** Session startup. `hyprland/hyprland.nix` puts the uwsm start in
`programs.zsh.profileExtra`, now `~/.config/zsh/.zprofile` — a path zsh reads
only because Home Manager keeps a `~/.zshenv` stub exporting `ZDOTDIR`. Deleting
that stub as stray leaves no error and no session.
**Also** `sessions.md#uwsm-login-shell` for the other half; this is set by hand
because `dotDir` keys off `stateVersion`, not `home.preferXdgDirectories`.

<a id="zsh-keymap"></a>
## `defaultKeymap = "emacs"`, and the re-source that follows it

**Why** zsh picks `viins` when `VISUAL` or `EDITOR` contains `vi`, and `EDITOR`
is `nvim`. Measured: `EDITOR=nvim zsh -f -i -c 'bindkey -lL main'` prints
`bindkey -A viins main`; unsetting it prints `emacs`. bash's readline is emacs,
so mirroring it means saying so.
**Breaks** *Silently.* `/etc/zshrc` sources `/etc/zinputrc`, which binds Home,
End, Insert, Delete and the page keys into whatever `main` pointed at — `viins`.
Home Manager's `bindkey -e` runs afterwards and relinks `main` to `emacs`,
stranding them. So `initContent` re-sources `/etc/zinputrc` after the switch,
guarded by `-r` so a home-manager aspect does not assert a NixOS path. Tested by
removing the line: all five keys report `undefined-key`, with no error at
startup. It is not a no-op — do not drop it.

<a id="zsh-menu-select"></a>
## `menu select` is what makes the completion list legible

**Why** `list-colors` alone renders a plain list: no entry is current, nothing
is highlighted, and the arrow keys still belong to the command line. `menu
select` loads `zsh/complist`, whose `menuselect` keymap binds the arrows. A
deliberate departure from mirroring bash, which has no menu at all.
**Also** the menu opens on the *second* tab — `AUTO_MENU` starts menu completion
on the next one — so a single tab followed by an arrow moves the cursor along
the command line and looks like a dead menu. Checking `zmodload -L` at startup
says `NOT loaded` and means nothing: the module arrives at the first completion.

## The menu's own colours, but not the file types'

**Why** Two things are coloured and they answer to different owners. Candidates
are file names, coloured from `LS_COLORS` so a listing and an `ls` agree —
replacing that with a palette-built database would desync the two. The menu's
furniture is ours: the selected row takes `ma=` in `desktop.colorsRgb`, base02
on base06, and the headings, messages and no-matches warning take base0C, base03
and base08 through `%F{...}`.
**Breaks** Nothing loudly. `ma=` is why the third consumer of
`desktop.colorsRgb` exists — `list-colors` takes raw SGR parameters, not hex.

## Syntax highlighting names every style

**Why** The defaults are ANSI names, which under all four terminals already
resolve to this palette — but stop being ours the moment the shell is reached
from elsewhere, the same reason `bat.nix` avoids its built-in base16 theme. So
every style is set from `colors16` as 24-bit `fg=#rrggbb`, through five bindings
in a `let` rather than thirty literals.
**Breaks** Order. Home Manager sources the plugin at `mkOrder 1200`, after
`initContent` at 1000, which is what the plugin needs — it wraps the widgets
that exist when sourced, so `edit-command-line` must be defined first.
zsh-autosuggestions is sourced at 700 and re-binds on every `precmd`, so it
wraps the wrapper rather than fighting it.
**Also** `fastSyntaxHighlighting` is the other option in the module, and an
assertion forbids enabling both.

## `^X^E` needs saying; readline binds it for free

**Why** The `edit-command-line` widget ships with zsh but is neither autoloaded
nor bound — `bindkey "^X^E"` reported `undefined-key`. Three lines in
`initContent` fix it, after the keymap switch so the binding lands in `emacs`.
**Also** the two are not identical: readline's runs the line on leaving the
editor, zle's replaces `$BUFFER` and hands it back, so it still wants Enter.

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
| `globstar` | **nothing needed** — recursive globbing is built in, `**/*.c` |
| `extglob` | `extended_glob` — same idea, not same syntax; `?(…)` wants `ksh_glob` |
| `nullglob` | `null_glob` — the one that genuinely changes behaviour |
| `dirspell` | **nothing.** `_approximate` was tried and dropped |
| `cdspell` | **nothing.** `correct`/`correct_all` prompt, and correct commands |

The completer list is `_complete _match`. `_approximate` came off: it fires only
once the first two find nothing, which is exactly when there is no good answer,
so what it adds is guesses. bash's `dirspell` corrects silently and never offers
alternatives — not the same trade.

<a id="noglob-nix"></a>
## `nix` is aliased to `noglob nix`, because `null_glob` eats flake refs

**Why** `extended_glob` makes `#` the "zero or more of the preceding" operator,
so `.#fetch-deps` is a glob pattern. It matches no file, and `null_glob` deletes
the word rather than erroring.
**Breaks** *Silently, and expensively.* `nix build .#fetch-deps` reaches nix as
a bare `nix build`, which fails saying `packages.<system>.default` does not
exist — an attribute nobody typed. `nix flake init -t github:owner/repo#template`
goes the same way. `noglob` suppresses filename generation for the rest of the
line, which is exactly right: nix parses flake refs itself.
**Also** it belongs in `programs.zsh.shellAliases`, not `home.shellAliases`
which bash also reads — `noglob` is a zsh reserved word and bash would answer
`noglob: command not found` on every invocation. Bash needs no equivalent; `#`
is not a pattern character there. An alias expands only as a command's first
word, so scripts and `command nix` are untouched.

## The prompt is one file, two implementations

**Why** zsh cannot reuse a line of the bash prompt — `%~` for `\w`, `precmd` for
`PROMPT_COMMAND`, `%F{#rrggbb}` for a hand-written SGR. They no longer draw the
same prompt either: the zsh half took a starship layout the bash half has not,
so the two share the slot map in the file's outer `let` and nothing else. What
must not drift is which palette slot means cwd, git, dev environment, ok and
error, and pinning that is the map's whole job.
**Also** `%F{#rrggbb}` rather than raw escapes lets zle compute the prompt width
itself, which is the whole of the classic zsh prompt-corruption bug. The one
exception is the branch's italic, which has no prompt escape — it is wrapped in
`%{…%}`, the zero-width marker, and measured: at 40 columns zsh wraps a typed
line as though the escape were not there. The sigil colour is `%(?.….…)`, so
nothing has to capture `$?` as its first statement the way the bash half must —
measured too, now that `__prompt` runs commands of its own.

<a id="zsh-prompt-git"></a>
## The zsh prompt reads git once, in porcelain v2

**Why** The layout wants a branch, an upstream divergence and three file states
— the toml leaves stashed, staged, renamed and deleted as empty strings, so
nothing looks for them. One `git --no-optional-locks status --porcelain=v2
--branch` answers the rest in the single fork the old `symbolic-ref` already
cost — 3.8 ms against 2.1 ms here, so starship's `command_timeout` has no
equivalent and needs none. `--no-optional-locks` keeps a prompt from taking the
index lock against a concurrent git, and the repo root is found by walking
`$PWD` for a `.git`, which is stat calls rather than a second fork.
**Breaks** *Silently, twice.* A computed segment is still prompt-expanded, so a
`%` in a branch name or a path is an escape unless doubled. And the marker order
is starship's `$all_status` — of its seven, conflicted, modified and untracked
survive, in that order — which nothing reveals until two are set at once.
**Also** an empty marker is a decision, not an omission: a fully staged tree is
meant to read as clean. `(detached)` in `# branch.head` is the cue to show the
short oid, where `symbolic-ref` used to drop the segment entirely.

## The prompt is transient, and its blank line is conditional

**Why** `add_newline` is a leading `\n` in `PROMPT`, which lands a blank line at
the top of a freshly cleared screen. A `__prompt_topline` flag suppresses it for
the first prompt of a session, after `clear` or `reset` (caught in `preexec`),
and on Ctrl-L — where the `clear-screen` widget is overridden to rebuild the
prompt before calling `.clear-screen`, because that widget redraws the existing
`PROMPT` rather than running `precmd`.
**Breaks** *Silently, and completely.* `add-zle-hook-widget` opens with
`zmodload -e zsh/zle || return 1`, and `zsh/zle` is not yet loaded while
`.zshrc` runs — so the call returns 1, registers nothing, and reports nothing.
The explicit `zmodload zsh/zle` above it is the whole reason transience works;
measured with `zle -l`, which listed no `zle-line-finish` without it. The later
`zle -N clear-screen` is what used to pull the module in, too late to help.
**Also** the transient prompt is the sigil alone, sharing `__prompt_sigil` with
the full one, so `%(?…)` at `line-finish` reports the status the prompt being
replaced was already showing — the command just accepted has not run yet.
`zle .reset-prompt` collapses the two-line prompt to one and emits a cursor-up,
reclaiming the blank line; that is what makes the scrollback compact.

## Both shells stay configured

bash remains swift5's login shell, stays installed on the Hyprland hosts, and
keeps `~/.profile` — which `xsession-wrapper` sources for every graphical
session regardless of login shell. Histories are separate, so suggestions start
cold.

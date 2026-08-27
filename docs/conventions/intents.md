# Intents

A capability a session *might* offer. Declared once, implemented per session.

## The shape

An **option namespace in `core`** with an empty default, plus a **setter in a
non-core aspect**. Usually both are in the same file, two memberships — that is
Inv. 3 working, not a violation.

| Namespace | Declared in (its `core` block) | Set from |
| --- | --- | --- |
| `launcher.argv` / `.command` | `launcher/launcher.nix` | `launcher/wmenu.nix` (`dwl`), `launcher/walker.nix` (`walker`), `quickshell/launcher.nix` (`quickshell`) |
| `terminal.*` | `terminal/terminal.nix` | `terminal/foot.nix` (`foot`), and `terminal/terminal.nix` itself sets `transientArgv` from `hyprland` |
| `fileManager.command` | `filemanager/thunar.nix` | `thunar.nix`, `filemanager/yazi.nix` |
| `lock.command` | `lock/lock.nix` | `lock/lock.nix` (`hyprland`, `dwl`) |
| `logout.command` | `powermenu/logout.nix` | `powermenu/logout.nix` (`hyprland`) |
| `powerMenu.command` | `powermenu/powermenu.nix` | `quickshell/quickshell.nix` (`quickshell`) |
| `audioMixer.command` | `media/toolbox.nix` | `media/toolbox.nix` (`core`) |
| `systemMonitor.command` / `.processorCommand` / `.memoryCommand` / `.temperatureCommand` | `cli/btop.nix` | `cli/btop.nix` (`apps`) |
| `bar.toggle` | `bar/bar.nix` | `quickshell/quickshell.nix` (`quickshell`) |
| `wallpaperMenu.command` | `wallpaper/menu.nix` | `wallpaper/picker.nix` (`walker`), `quickshell/quickshell.nix` (`quickshell`) |
| `wallpaper.set` / `.enableRotator` / `.disableRotator` / `.directory` | `wallpaper/actions.nix` | `wallpaper/actions.nix` (`hyprland`) |
| `wallpaper.thumbnailManifest` | `wallpaper/thumbnails.nix` | `wallpaper/thumbnails.nix` (`hyprland`) |
| `editor.package` (defaults to `neovim.min`, not empty) | `editor/neovim.nix` | `editor/neovim.nix` (`dev`) |

`launcher`, `terminal` and `wallpaperMenu` have files to themselves, because
their implementations genuinely compete — the namespace file must not name any
of them. `terminal/terminal.nix` also holds a setter, which is only allowed because that
setter is implementation-independent: it composes through `appIdArgv` and so
never needs editing when a terminal is added.

## An empty default is a statement

`bar.toggle` empty says dwl toggles its compiled-in bar itself, and
`powerMenu.command` empty says swift5 has no power menu. Neither is an
oversight. `lock.command` was empty for the same kind of reason until dwl got
swayidle and swaylock; both sessions now set the same `loginctl lock-session`,
because the value names an intent and not a program.

## Omit rather than render dead

Consumers guard on the empty default and emit **nothing**:

```nix
++ lib.optionals (config.fileManager.command != "") [ … ]
// lib.optionalAttrs (config.powerMenu.command != "") { … }
```

A keybind that runs nothing looks like a broken machine. An absent bind explains
itself. Sites: `hyprland/binds.nix`, `quickshell/_qml/`.

## The aspect that installs the tool names it

The session renders what it finds; it does not name programs. `$mod+E` once
named `thunar` from inside the `hyprland` aspect while only `apps` installed it,
so a Hyprland host without `apps` got a bind that silently did nothing.

## `argv` and `command` are one value rendered twice

dwl's binds are a **C argv array**; Hyprland's are **shell strings**.

**Compose at argv level and render once.** `terminal.transientCommand` is
already escaped — appending to it escapes twice. Build the full argv and call
`lib.escapeShellArgs` exactly once (`filemanager/yazi.nix`).

## Bind the value; do not read the merged option back

`filemanager/yazi.nix` binds its command directly. The merged option is what a
`mkForce` elsewhere would win — and then a desktop entry named "Yazi" execs
thunar.

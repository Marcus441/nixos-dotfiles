# Intents

A capability a session *might* offer. Declared once, implemented per session.

## The shape

An **option namespace in `core`** with an empty default, plus a **setter in a
non-core aspect**. Usually both are in the same file, two memberships — that is
Inv. 3 working, not a violation.

| Namespace | Declared in (its `core` block) | Set from |
| --- | --- | --- |
| `launcher.argv` / `.command` | `launcher.nix` | `wmenu.nix` (`dwl`), `walker.nix` (`hyprland`) |
| `terminal.*` | `foot.nix` | `foot.nix`, in `core` — both sessions share it |
| `fileManager.command` | `filemanager/thunar.nix` | `thunar.nix`, `filemanager/yazi.nix` |
| `lock.command` | `lock.nix` | `lock.nix` (`hyprland`) |
| `logout.command` | `logout.nix` | `logout.nix` (`hyprland`) |
| `powerMenu.command` | `wleave.nix` | `wleave.nix` (`wleave`) |
| `networkManager.command` | `impala.nix` | `impala.nix` (`impala`) |
| `systemMonitor.command` / `.memoryCommand` | `cli/btop.nix` | `cli/btop.nix` (`apps`) |
| `bar.toggle` | `bar/waybar.nix` | `bar/waybar.nix` (`waybar`) |

`launcher` is the only one with a file to itself, because wmenu and walker
genuinely compete for it — the namespace file must not name either.

## An empty default is a statement

`lock.command` empty says swift5's dwl session has no locker. `bar.toggle` empty
says dwl toggles its compiled-in bar itself. Neither is an oversight.

## Omit rather than render dead

Consumers guard on the empty default and emit **nothing**:

```nix
++ lib.optionals (config.fileManager.command != "") [ … ]
// lib.optionalAttrs (config.powerMenu.command != "") { … }
```

A keybind that runs nothing looks like a broken machine. An absent bind explains
itself. Sites: `hyprland-binds.nix`, `bar/waybar.nix`, `wleave.nix`.

## The aspect that installs the tool names it

The session renders what it finds; it does not name programs. `$mod+E` once
named `thunar` from inside the `hyprland` aspect while only `apps` installed it,
so a Hyprland host without `apps` got a bind that silently did nothing.

## `argv` and `command` are one value rendered twice

dwl's binds are a **C argv array**; Hyprland's are **shell strings**.

**Compose at argv level and render once.** `terminal.transientCommand` is
already escaped — appending to it escapes twice. Build the full argv and call
`lib.escapeShellArgs` exactly once (`filemanager/yazi.nix`, `impala.nix`).

## Bind the value; do not read the merged option back

`filemanager/yazi.nix` binds its command directly. The merged option is what a
`mkForce` elsewhere would win — and then a desktop entry named "Yazi" execs
thunar.

# Placement

Which aspect and which class a value belongs to.

## `core` carries inert data; a session aspect carries assertions

The easiest one to get wrong.

- `windowTags` is `core`. Its values are **inert data** — a regex a session may
  ignore. swift5 carries them with no reader and builds byte-identical.
- Floating **app-ids** are `hyprland`. An app-id is **not** inert: it changes
  the argv a spawn point executes, so a dwl host would run commands asserting a
  window behaviour its compositor rejects.

Ask whether the value *does* anything on a host that ignores it.

## One file, two classes

A concern needing a home-manager option *and* a systemd unit is still one
concern, so it stays one file declaring both memberships (Inv. 3).

- `filemanager/thunar.nix` — home config plus a nixos user service.
- `bar/dwl-bar.nix` — a home aspect, plus `dwl.statusCommand` crossed to nixos
  because the session script holding the pipe cannot see homeManager config.

## `aspectRequires` is declared by the file that creates the dependency

Not by a central table, which would drift. The generator rejects a host that
leaves one unmet, naming the host and the aspect.

- `bar/dwl-bar.nix` → `dwl`
- `bar/waybar.nix` → `hyprland`
- `filemanager/yazi.nix` → `apps`

## Prefer a store path; bare name only where PATH is required

`terminal/foot.nix` publishes `config.terminal` by store path. `wmenu.nix` keeps wmenu on
PATH only for the human, because dwl compiles the argv into its C keybind array.

The corollary: a tool invoked **by bare name** must be installed by every aspect
that invokes it. `brightnessctl.nix` declares both `hyprland` and `laptop` for
exactly this reason.

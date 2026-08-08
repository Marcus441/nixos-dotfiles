---
paths: "modules/**/*.nix"
---

# Sharing values between files

In order of preference:

1. **`let` binding** — when only that file needs it.
2. **A flake-parts option** — when other files need it. Capture the flake-parts
   `config` in an outer `let`; inside `flake.modules.*`, `config` is the
   *guest* config, not flake-parts'. Getting this wrong produces infinite
   recursion, not a clear error.
3. **`_module.args`, injected by the host wiring** — for values that vary per
   host (monitors, hostname). An aspect is a single value shared by every host
   that takes it — there is nothing for a closure to specialise on (Inv. 7).

**`_module.args` cannot compute `imports`** — resolving imports happens before
config, so using an injected arg to decide imports is infinite recursion. If an
import needs to depend on a host fact, that fact is a *decision*, and decisions
belong in the host's aspect list.

**Forbidden:** `specialArgs`, `extraSpecialArgs`, threading `self`/`inputs`
into a nested evaluation, importing a module file by path to call a function.

## Provider/consumer split

When two implementations share an intent but no code, the portable part is an
**option namespace** in `core` and the implementations are **separate
aspects**. The setter sits in the provider's file, not in the namespace's file
— otherwise the namespace file would be edited every time a provider changed
(Inv. 3 inverted).

- `modules/launcher.nix` — declares `launcher.argv` in `core` (the intent).
- `modules/walker.nix` — sets it from `hyprland`.
- `modules/wmenu.nix` — sets it from `dwl`.

**A shared namespace is sometimes empty.** `clipboard`, `lock`, and
`screenshot` share intent across sessions but were never abstracted into a
common namespace — the shared config is declared per-session inside the one
file that owns the concern. Zero shared aspects is a valid outcome.

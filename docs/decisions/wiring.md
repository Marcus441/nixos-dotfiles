# Wiring

The generator, the host record, and the aspect options.

<a id="aspects-deferred"></a>
## `aspects.nix` — elements are `deferredModule`, not `raw`

**Why** `deferredModule` buys back `_file`.
**Breaks** With `raw`, an option conflict reports `<unknown-file>` twice and you
binary-search for the two files that collided.

<a id="aspects-requires"></a>
## `aspects.nix` — `aspectRequires`

**Why** Declared by the file that creates the dependency, so it cannot drift
from the code that needs it.
**Breaks** Without it, an aspect reading another aspect's options fails as an
eval error inside a guest module, naming neither the host nor the missing
aspect.

<a id="generator-classes"></a>
## `hosts/generator.nix` — the explicit `classes` list

**Why** `flake.modules` is an open attrset, so `flake.modules.homemanager.core`
type-checks and is read by nobody.
**Breaks** *Silently.* A typo'd class name drops every module under it with no
error. Measured: a host built fine with the option it set simply absent.

<a id="generator-partition"></a>
## `hosts/generator.nix` — the class is derived from the platform string

**Why** A host's `system` already says which class builds it. A second record
field (`class = "darwin"`) could disagree with it, and the disagreement would
be a wrong build rather than an error. `hasSuffix "-darwin"` is the whole
rule: the darwin partition goes through `darwinSystem`, the rest through
`nixosSystem`, and every host gets a home.
**Breaks** Loudly. A `-darwin` host handed to `nixosSystem` fails on
nixpkgs' platform assertions before it reaches a module.

<a id="generator-depth"></a>
## `hosts/generator.nix` — the nested `{imports = …;}`

**Why** Merge order follows the module tree, and the nesting holds aspects at
the depth the pre-refactor entry points sat at.
**Breaks** *Silently.* Flattening it moves merge order → `buildEnv` order →
derivation hashes, on every host.

<a id="generator-checks"></a>
## `hosts/generator.nix` — checks as folded data, not nested `throwIf`s

**Why** A bogus aspect name must be reported before the requirements that could
not resolve because of it.
**Breaks** `foldl'` forces every step as it goes, so the **first** entry fires
**first** and the list reads in firing order. Measured: a host with a bogus
aspect and an unmet requirement reports the bogus aspect. Appending a check
makes it fire last.

<a id="generator-strict"></a>
## `hosts/generator.nix` — the strict argument pattern

**Why** `monitors` and `input` are matched but unused, which forces a new host
option to be wired here. `makeDarwin` matches `hardware` the same way: it is
`null` on every darwin host, and the check that says so is the one place that
reads it.
**Breaks** With a `...`, a new host-record field is silently ignored.

<a id="record-strict"></a>
## `hosts/record.nix` — no `freeformType`

**Why** An unrecognised field is a typo, and should be rejected where written.
**Breaks** Otherwise the generator's strict pattern reports it as a missing
argument at the far end.

<a id="record-hardware-null"></a>
## `hosts/record.nix` — `hardware` is `nullOr path` with no default

**Why** A Mac has no `hardware-configuration.nix`, so the field must admit
`null` — but as a value a host writes, never a default, so a NixOS host that
forgets its hardware file is rejected rather than built without its disks.
The generator's check pairs the two: `null` on a Linux host and a path on a
darwin host are both errors that name the field.
**Breaks** Loudly, by construction. The check sits last in the fold, so it
fires last, after the aspect checks — a bogus aspect list is still reported
first. Measured: gpc with `hardware = null` and a bogus aspect names the
aspect.

<a id="record-machine"></a>
## `hosts/record.nix` — `machine` has no default

**Why** Every host sets `networking.hostName` and `system.stateVersion` here and
nowhere else.
**Breaks** *Silently.* A default makes an omission build a machine called
`nixos` at whatever stateVersion nixpkgs defaults to. Measured, not assumed.

## `hosts/record.nix` — `input.sensitivity` is not a display property

**Why** It shared `monitors.nix` only because that file was really a per-host
input/output bag.

{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (inputs) home-manager nixpkgs;

  user = "marcus";
  homeStateVersion = "25.11";

  # Merge order of list-valued options follows the module tree, and reaches a
  # derivation hash. The nested `{imports = ...;}` below are not decoration:
  # they hold the aspects at the depth the pre-refactor entry points sat at.
  aspectModules = class: aspects:
    lib.concatMap
    (name: config.flake.modules.${class}.${name} or [])
    aspects;

  # `flake.modules` is an open attrset, so `flake.modules.homemanager.core`
  # type-checks, is read by nobody, and drops its modules in silence. Measured:
  # a host built fine with the option it set simply absent. Enumerating the
  # classes in the option type catches it at the declaring file instead, but
  # that was measured to move all six targets; this is the same check for free.
  classes = ["nixos" "homeManager"];

  unknownClasses =
    lib.filter (c: !lib.elem c classes) (lib.attrNames config.flake.modules);

  # An aspect may define only one class -- `dev` is nixos-only -- so
  # aspectModules has to tolerate a miss. That makes a typo silently produce a
  # host with modules missing rather than an error, hence this check.
  unknownAspects = aspects:
    lib.filter
    (name: !lib.any (class: config.flake.modules.${class} ? ${name}) (lib.attrNames config.flake.modules))
    aspects;

  # `aspectRequires` merges from the files that read another aspect's options
  # (aspects.nix). Without this the failure is `attribute 'stylix' missing`
  # pointing at a line in a guest module, naming neither the host nor the aspect
  # that is actually missing.
  unmetRequires = aspects:
    lib.unique (lib.concatMap
      (a:
        map (r: "${a} needs ${r}")
        (lib.filter (r: !lib.elem r aspects) (config.aspectRequires.${a} or [])))
      aspects);

  # A requirement is only ever consulted under a key that is itself an aspect, so
  # a typo'd key is a requirement that silently never fires -- the failure this
  # whole check exists to remove, one level up.
  unknownRequireKeys = unknownAspects (lib.attrNames config.aspectRequires);

  # Data rather than nesting: five throwIfs deep, the nesting hid the order, and
  # the order is the point -- a bogus aspect name must be reported before the
  # requirements that could not resolve because of it. Each fold step wraps the
  # accumulator, so the LAST entry is the outermost and fires FIRST; the list
  # below reads bottom-to-top.
  checkHost = name: host:
    lib.foldl' (acc: c: lib.throwIf c.cond c.msg acc) host [
      {
        cond = unmetRequires host.aspects != [];
        msg = "hosts.${name}: unmet aspect requirement -- ${lib.concatStringsSep "; " (unmetRequires host.aspects)}";
      }
      {
        cond = unknownAspects host.aspects != [];
        msg = "hosts.${name}: unknown aspect ${lib.concatStringsSep ", " (unknownAspects host.aspects)}";
      }
      {
        cond = unknownRequireKeys != [];
        msg = "aspectRequires: unknown aspect ${lib.concatStringsSep ", " unknownRequireKeys}";
      }
      {
        cond = host.hostname != name;
        msg = "hosts.${name}: hostname is \"${host.hostname}\"; the attribute name is the host name";
      }
      {
        cond = unknownClasses != [];
        msg = "flake.modules: unknown class ${lib.concatStringsSep ", " unknownClasses}; expected one of ${lib.concatStringsSep ", " classes}";
      }
    ];

  # `packages` and `nixos` sit at different depths on purpose -- see the note on
  # aspectModules. `monitors` and `input` are matched but unused: the host record
  # is typed, so a typo is now caught at the definition site, but the strict
  # pattern still forces a newly declared host option to be wired here rather
  # than silently ignored.
  makeSystem = {
    hostname,
    system,
    stateVersion,
    aspects,
    hardware,
    monitors,
    input,
    fontSize,
    packages,
    nixos,
  }:
    nixpkgs.lib.nixosSystem {
      modules = [
        {_module.args = {inherit stateVersion hostname user;};}
        {nixpkgs.hostPlatform = system;}
        {
          imports = [
            hardware
            packages
            {imports = aspectModules "nixos" aspects;}
          ];
        }
        nixos
      ];
    };

  mkHome = {
    hostname,
    system,
    aspects,
    monitors,
    input,
    fontSize,
    ...
  }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [
        {
          _module.args =
            {inherit hostname monitors fontSize;}
            // {inherit (input) sensitivity;};
        }
        {
          imports = [
            {imports = aspectModules "homeManager" aspects;}
          ];
        }
        {
          home = {
            username = user;
            homeDirectory = "/home/${user}";
            stateVersion = homeStateVersion;
            sessionVariables = {
              NIXOS_OZONE_WL = "1";
              QT_QPA_PLATFORM = "wayland";
              XDG_SCREENSHOTS_DIR = "/home/${user}/Screenshots";
            };
          };
        }
      ];
    };
in {
  config = {
    systems = ["x86_64-linux"];

    # Both output sets are keyed off the attribute name, so they cannot drift
    # apart; checkHost pins the record's hostname to it as well.
    flake.nixosConfigurations =
      lib.mapAttrs (name: host: makeSystem (checkHost name host)) config.hosts;

    flake.homeConfigurations =
      lib.mapAttrs' (
        name: host: lib.nameValuePair "${user}@${name}" (mkHome (checkHost name host))
      )
      config.hosts;
  };
}

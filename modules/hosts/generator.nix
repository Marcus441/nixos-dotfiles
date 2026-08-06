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

  # An aspect may define only one class -- `dev` is nixos-only -- so
  # aspectModules has to tolerate a miss. That makes a typo silently produce a
  # host with modules missing rather than an error, hence this check.
  unknownAspects = aspects:
    lib.filter
    (name: !lib.any (class: config.flake.modules.${class} ? ${name}) (lib.attrNames config.flake.modules))
    aspects;

  checkHost = name: host:
    lib.throwIf (host.hostname != name)
    "hosts.${name}: hostname is \"${host.hostname}\"; the attribute name is the host name"
    (
      lib.throwIf (unknownAspects host.aspects != [])
      "hosts.${name}: unknown aspect ${lib.concatStringsSep ", " (unknownAspects host.aspects)}"
      host
    );

  # `packages` and `nixos` sit at different depths on purpose -- see the note on
  # aspectModules. `monitors` and `input` are matched but unused: the pattern is
  # strict so a typo in an untyped host field is an error here rather than a
  # silently missing module.
  makeSystem = {
    hostname,
    system,
    stateVersion,
    aspects,
    hardware,
    monitors,
    input,
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
    ...
  }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [
        {
          _module.args =
            {inherit user hostname homeStateVersion monitors;}
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

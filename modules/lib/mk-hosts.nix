{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (inputs) home-manager nixpkgs;

  user = "marcus";
  homeStateVersion = "25.11";
  utils = import config.legacy.utilities;

  # Merge order of list-valued options follows the module tree, and reaches a
  # derivation hash. The nested `{imports = ...;}` below are not decoration:
  # they put the aspects at the depth nixos/core and home-manager/core held.
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

  makeSystem = {
    hostname,
    system,
    stateVersion,
    profile,
    dev,
    aspects,
  }: let
    monitors = import (config.legacy.monitors hostname) utils;
  in
    nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs stateVersion hostname user monitors profile dev;};
      modules = [
        {nixpkgs.hostPlatform = system;}
        {
          imports = [
            (config.legacy.hostFile hostname "hardware-configuration.nix")
            (config.legacy.hostFile hostname "local-packages.nix")
            {imports = aspectModules "nixos" aspects;}
          ];
        }
        (config.legacy.nixosHost hostname)
      ];
    };

  mkHome = {
    hostname,
    system,
    profile,
    dev,
    aspects,
    ...
  }: let
    monitorConfig = import (config.legacy.monitors hostname) utils;
    inherit (monitorConfig) monitors;
    inherit (monitorConfig) sensitivity;
  in
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit inputs user hostname homeStateVersion monitors sensitivity profile dev;
      };
      modules =
        nixpkgs.lib.optionals (profile == "maximal") [
          inputs.stylix.homeModules.stylix
          inputs.walker.homeManagerModules.default
        ]
        ++ [
          {
            imports = [
              {imports = aspectModules "homeManager" aspects;}
            ];
          }
          config.legacy.homeEntry
        ];
    };
in {
  options.hosts = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf lib.types.raw);
    default = {};
  };

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

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

  makeSystem = {
    hostname,
    system,
    stateVersion,
    profile,
    dev,
  }: let
    monitors = import (config.legacy.monitors hostname) utils;
  in
    nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs stateVersion hostname user monitors profile dev;};
      modules = [
        {nixpkgs.hostPlatform = system;}
        (config.legacy.nixosHost hostname)
      ];
    };

  mkHome = {
    hostname,
    system,
    profile,
    dev,
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
        ++ [config.legacy.homeEntry];
    };
in {
  options.hostRecords = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf lib.types.raw);
    default = {};
  };

  config = {
    systems = ["x86_64-linux"];

    flake.nixosConfigurations = lib.mapAttrs (_: makeSystem) config.hostRecords;

    flake.homeConfigurations =
      lib.mapAttrs' (
        _: host: lib.nameValuePair "${user}@${host.hostname}" (mkHome host)
      )
      config.hostRecords;
  };
}

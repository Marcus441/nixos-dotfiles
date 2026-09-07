{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (inputs) home-manager nix-darwin nixpkgs;

  user = "marcus";
  homeStateVersion = "25.11";

  # load-bearing: docs/decisions/wiring.md#generator-depth
  aspectModules = class: aspects:
    lib.concatMap
    (name: config.flake.modules.${class}.${name} or [])
    aspects;

  # load-bearing: docs/decisions/wiring.md#generator-classes
  classes = ["nixos" "homeManager" "darwin"];

  # load-bearing: docs/decisions/wiring.md#generator-partition
  isDarwinSystem = lib.hasSuffix "-darwin";
  isDarwin = host: isDarwinSystem host.system;

  unknownClasses =
    lib.filter (c: !lib.elem c classes) (lib.attrNames config.flake.modules);

  unknownAspects = aspects:
    lib.filter
    (name: !lib.any (class: config.flake.modules.${class} ? ${name}) (lib.attrNames config.flake.modules))
    aspects;

  unmetRequires = aspects:
    lib.unique (lib.concatMap
      (a:
        map (r: "${a} needs ${r}")
        (lib.filter (r: !lib.elem r aspects) (config.aspectRequires.${a} or [])))
      aspects);

  unknownRequireKeys = unknownAspects (lib.attrNames config.aspectRequires);

  # load-bearing: docs/decisions/wiring.md#generator-checks
  checkHost = name: host:
    lib.foldl' (acc: c: lib.throwIf c.cond c.msg acc) host [
      {
        cond = unknownClasses != [];
        msg = "flake.modules: unknown class ${lib.concatStringsSep ", " unknownClasses}; expected one of ${lib.concatStringsSep ", " classes}";
      }
      {
        cond = host.hostname != name;
        msg = "hosts.${name}: hostname is \"${host.hostname}\"; the attribute name is the host name";
      }
      {
        cond = unknownRequireKeys != [];
        msg = "aspectRequires: unknown aspect ${lib.concatStringsSep ", " unknownRequireKeys}";
      }
      {
        cond = unknownAspects host.aspects != [];
        msg = "hosts.${name}: unknown aspect ${lib.concatStringsSep ", " (unknownAspects host.aspects)}";
      }
      {
        cond = unmetRequires host.aspects != [];
        msg = "hosts.${name}: unmet aspect requirement -- ${lib.concatStringsSep "; " (unmetRequires host.aspects)}";
      }
      {
        # load-bearing: docs/decisions/wiring.md#record-hardware-null
        cond = (host.hardware == null) != isDarwin host;
        msg =
          if isDarwin host
          then "hosts.${name}: a darwin host has no hardware-configuration.nix; write hardware = null"
          else "hosts.${name}: hardware is null, and a NixOS host needs its hardware-configuration.nix";
      }
    ];

  # load-bearing: docs/decisions/wiring.md#generator-strict
  makeSystem = {
    hostname,
    system,
    stateVersion,
    aspects,
    hardware,
    monitors,
    input,
    fontSize,
    bar,
    packages,
    machine,
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
        machine
      ];
    };

  makeDarwin = {
    hostname,
    system,
    stateVersion,
    aspects,
    hardware,
    monitors,
    input,
    fontSize,
    bar,
    packages,
    machine,
  }:
    nix-darwin.lib.darwinSystem {
      modules = [
        {_module.args = {inherit stateVersion hostname user;};}
        {nixpkgs.hostPlatform = system;}
        {
          imports = [
            packages
            {imports = aspectModules "darwin" aspects;}
          ];
        }
        machine
      ];
    };

  mkHome = {
    hostname,
    system,
    aspects,
    monitors,
    input,
    fontSize,
    bar,
    ...
  }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [
        {
          _module.args =
            {inherit hostname monitors fontSize;}
            // {inherit (input) sensitivity;}
            // {barPosition = bar.position;};
        }
        {
          imports = [
            {imports = aspectModules "homeManager" aspects;}
          ];
        }
        {
          home = {
            username = user;
            homeDirectory =
              if isDarwinSystem system
              then "/Users/${user}"
              else "/home/${user}";
            stateVersion = homeStateVersion;
          };
        }
      ];
    };

  checked = lib.mapAttrs checkHost config.hosts;
in {
  config = {
    systems = ["x86_64-linux" "aarch64-darwin"];

    flake.nixosConfigurations =
      lib.mapAttrs (_: makeSystem) (lib.filterAttrs (_: host: !isDarwin host) checked);

    flake.darwinConfigurations =
      lib.mapAttrs (_: makeDarwin) (lib.filterAttrs (_: isDarwin) checked);

    flake.homeConfigurations =
      lib.mapAttrs' (name: host: lib.nameValuePair "${user}@${name}" (mkHome host)) checked;
  };
}

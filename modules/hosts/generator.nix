{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (inputs) home-manager nixpkgs;

  user = "marcus";
  homeStateVersion = "25.11";

  # load-bearing: docs/decisions/wiring.md#generator-depth
  aspectModules = class: aspects:
    lib.concatMap
    (name: config.flake.modules.${class}.${name} or [])
    aspects;

  # load-bearing: docs/decisions/wiring.md#generator-classes
  classes = ["nixos" "homeManager"];

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

    flake.nixosConfigurations =
      lib.mapAttrs (name: host: makeSystem (checkHost name host)) config.hosts;

    flake.homeConfigurations =
      lib.mapAttrs' (
        name: host: lib.nameValuePair "${user}@${name}" (mkHome (checkHost name host))
      )
      config.hosts;
  };
}

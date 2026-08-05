{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (inputs) home-manager nixpkgs;

  user = "marcus";
  homeStateVersion = "25.11";

  # Neutral, compositor-agnostic monitor description; each consumer renders it
  # into its own format. Phase 3 replaces this with typed options.
  utils.makeMonitor = name: width: height: refresh: x: y: scale: {
    inherit name width height refresh x y scale;
  };

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
  # aspectModules.
  makeSystem = {
    hostname,
    system,
    stateVersion,
    aspects,
    hardware,
    monitors,
    packages,
    nixos,
  }: let
    monitorConfig = monitors utils;
  in
    nixpkgs.lib.nixosSystem {
      specialArgs =
        {inherit inputs stateVersion hostname user;}
        # NixOS takes the whole record, home takes it apart. Phase 3 fixes this.
        // {monitors = monitorConfig;};
      modules = [
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
    ...
  }: let
    monitorConfig = monitors utils;
  in
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs =
        {inherit inputs user hostname homeStateVersion;}
        // {inherit (monitorConfig) monitors sensitivity;};
      modules =
        # Not movable into modules/maximal/*: these sit at the root of the
        # module list, and importing them from the aspect puts them two levels
        # deeper, which reorders home.packages.
        lib.optionals (lib.elem "maximal" aspects) [
          inputs.stylix.homeModules.stylix
          inputs.walker.homeManagerModules.default
        ]
        ++ [
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

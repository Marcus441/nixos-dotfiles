{
  description = "My system configuration";

  inputs = {
    elephant.url = "github:abenz1267/elephant";
    helium.url = "github:FKouhai/helium2nix/main";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-config = {
      url = "github:Marcus441/neovim.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    homeStateVersion = "25.11";
    user = "marcus";
    hosts = [
      {
        hostname = "swift5";
        stateVersion = "25.11";
      }
      {
        hostname = "gpc";
        stateVersion = "25.11";
      }
      {
        hostname = "UM790pro";
        stateVersion = "25.11";
      }
    ];

    makeSystem = {
      hostname,
      stateVersion,
    }: let
      utils = import ./utilities;
      monitors = import ./hosts/${hostname}/monitors.nix utils;
    in
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs stateVersion hostname user monitors;};
        modules = [
          {nixpkgs.hostPlatform = system;}
          ./hosts/${hostname}/configuration.nix
        ];
      };

    mkHome = hostname: let
      utils = import ./utilities;
      monitors = import ./hosts/${hostname}/monitors.nix utils;
    in
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {
          inherit inputs user hostname homeStateVersion monitors;
        };
        modules = [
          inputs.nix-index-database.homeModules.default
          inputs.stylix.homeModules.stylix
          inputs.walker.homeManagerModules.default
          ./home-manager/home.nix
        ];
      };

    homeConfigs = builtins.listToAttrs (map (host: {
        name = "${user}@${host.hostname}";
        value = mkHome host.hostname;
      })
      hosts);
  in {
    nixosConfigurations =
      nixpkgs.lib.foldl' (
        configs: host:
          configs
          // {
            "${host.hostname}" = makeSystem host;
          }
      ) {}
      hosts;

    homeConfigurations = homeConfigs;
  };
}

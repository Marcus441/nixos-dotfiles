{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    elephant.url = "github:abenz1267/elephant";

    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    homeStateVersion = "24.11";
    user = "marcus";
    hosts = [
      {
        hostname = "swift5";
        stateVersion = "24.11";
      }
      {
        hostname = "gpc";
        stateVersion = "24.11";
      }
      {
        hostname = "UM790pro";
        stateVersion = "24.11";
      }
    ];

    makeSystem = {
      hostname,
      stateVersion,
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs stateVersion hostname user;};
        modules = [
          ./hosts/${hostname}/configuration.nix
        ];
      };

    mkHome = hostname:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {
          inherit inputs user hostname homeStateVersion;
        };
        modules = [
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

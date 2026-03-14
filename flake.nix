{
  description = "My system configuration";

  inputs = {
    helium.url = "github:FKouhai/helium2nix/main";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
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

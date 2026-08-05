{...}: {
  flake.modules.nixos.core = [
    {
      nix = {
        registry.templates.to = {
          type = "github";
          owner = "Marcus441";
          repo = "nix-templates";
        };

        settings = {
          experimental-features = ["nix-command" "flakes"];
          auto-optimise-store = true;
          warn-dirty = false;
          extra-substituters = [
            "https://nix-community.cachix.org"
            "https://nvf.cachix.org"
          ];
          extra-trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "nvf.cachix.org-1:GMQWiUhZ6ux9D5CvFFMwnc2nFrUHTeGaXRlVBXo+naI="
          ];
        };
      };
    }
  ];
}

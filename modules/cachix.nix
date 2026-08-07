_: {
  # danth is stylix's. Walker's two live with walker, in hyprland -- a cache in
  # the aspect that does not build the thing is either a dead substituter or a
  # source build, depending on which way the host list falls.
  flake.modules.nixos.stylix = [
    {
      nix.settings = {
        extra-substituters = ["https://danth.cachix.org"];
        extra-trusted-public-keys = [
          "danth.cachix.org-1:1ow3ZHcCp6ujnzcK/FPR0gqMMoWijV9foAPvCliY0bQ="
        ];
      };
    }
  ];
}

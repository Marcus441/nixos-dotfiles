_: {
  flake.modules.homeManager.dev = [
    (
      {config, ...}: let
        inherit (config.desktop) colors;
      in {
        programs.lazydocker = {
          enable = true;
          settings = {
            gui.theme = {
              # load-bearing: docs/decisions/theming.md#lazygit
              selectedLineBgColor = ["default"];

              activeBorderColor = [colors.base0D "bold"];
              inactiveBorderColor = [colors.base03];
              optionsTextColor = [colors.base06];
            };
          };
        };
      }
    )
  ];
}

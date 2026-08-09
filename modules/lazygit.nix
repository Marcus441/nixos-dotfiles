_: {
  flake.modules.homeManager.apps = [
    (
      {config, ...}: let
        inherit (config.desktop) colors;
      in {
        programs.lazygit = {
          enable = true;
          settings = {
            gui = {
              showFileIcons = true;
              nerdFontsVersion = 3;
              theme = {
                lightTheme = false;

                # load-bearing: docs/decisions/theming.md#lazygit
                selectedLineBgColor = ["default"];

                activeBorderColor = [colors.base0D "bold"];
                inactiveBorderColor = [colors.base03];
                searchingActiveBorderColor = [colors.base04 "bold"];
                defaultFgColor = [colors.base05];
                optionsTextColor = [colors.base06];
                unstagedChangesColor = [colors.base08];
                cherryPickedCommitBgColor = [colors.base02];
                cherryPickedCommitFgColor = [colors.base03];
              };
            };
          };
        };
      }
    )
  ];
}

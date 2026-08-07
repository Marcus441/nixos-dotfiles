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

                # `default` rather than a colour: the selected line keeps the
                # terminal's own background, so the cursor line does not fight
                # foot's.
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

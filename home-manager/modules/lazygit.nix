{lib, ...}: {
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showFileIcons = true;
        nerdFontsVersion = 3;
        theme = {
          lightTheme = false;
          selectedLineBgColor = lib.mkForce ["default"];
        };
      };
    };
  };
}

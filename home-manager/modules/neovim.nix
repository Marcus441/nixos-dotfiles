{
  pkgs,
  inputs,
  ...
}: {
  home = {
    packages = [
      inputs.neovim-config.packages.${pkgs.system}.default
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };
  };
  xdg.desktopEntries = {
    nvim = {
      name = "Neovim";
      genericName = "Text Editor";
      exec = "nvim %F";
      terminal = true;
      categories = ["Utility" "TextEditor" "Development"];
      mimeType = ["text/plain" "text/markdown" "text/x-csrc" "text/x-chdr" "text/x-python" "application/x-ruby"];
      icon = "nvim";
    };
  };
}

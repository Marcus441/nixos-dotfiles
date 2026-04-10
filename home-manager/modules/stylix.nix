{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.stylix.homeModules.stylix
  ];
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-lgc-plus
    noto-fonts-color-emoji
    font-awesome
    nerd-fonts.jetbrains-mono
    source-code-pro
  ];

  stylix = {
    enable = true;
    autoEnable = false;

    base16Scheme = {
      base00 = "#181616"; # bg
      base01 = "#0d0c0c"; # bg_alt
      base02 = "#2d4f67"; # base2
      base03 = "#a6a69c"; # grey
      base04 = "#7fb4ca"; # fg_alt
      base05 = "#c5c9c5"; # fg
      base06 = "#938aa9"; # base7
      base07 = "#c5c9c5"; # base8
      base08 = "#c4746e"; # red
      base09 = "#e46876"; # orange
      base0A = "#c4b28a"; # yellow
      base0B = "#8a9a7b"; # green
      base0C = "#8ea4a2"; # teal
      base0D = "#8ba4b0"; # blue
      base0E = "#a292a3"; # magenta
      base0F = "#7aa89f"; # violet
    };
    polarity = "dark";
    targets = {
      bat.enable = true;
      fish.enable = true;
      gtk.enable = true;
      hyprland.enable = true;
      hyprlock.enable = true;
      lazygit.enable = true;
      mako.enable = true;
      neovide.fonts.enable = true;
      # opencode.enable = true;
      qt.enable = true;
      yazi.enable = true;
      zathura.enable = true;
    };

    cursor = {
      name = "Adwaita";
      size = 24;
      package = pkgs.adwaita-icon-theme;
    };

    fonts = {
      monospace = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
      sansSerif = {
        name = "Inter";
        package = pkgs.inter;
      };
      serif = {
        name = "Noto Serif";
        package = pkgs.noto-fonts;
      };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };
      sizes = {
        applications = 13;
        terminal = 14;
        desktop = 12;
        popups = 12;
      };
    };

    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };
  };

  gtk.gtk4.theme = config.gtk.theme;
}

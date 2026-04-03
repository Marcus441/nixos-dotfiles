{
  pkgs,
  inputs,
  config,
  ...
}: let
  image = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/o3/wallhaven-o32do5.jpg";
    hash = "sha256-a6stwKasoy6V6XpfqgclWiP7NSw/kAVShHkI+gx3vIE=";
  };
in {
  imports = [inputs.stylix.homeModules.stylix];

  home.packages = with pkgs; [
    dejavu_fonts
    noto-fonts
    noto-fonts-lgc-plus
    noto-fonts-color-emoji
    font-awesome
    powerline-fonts
    powerline-symbols
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
    source-code-pro
  ];

  stylix = {
    enable = true;
    autoEnable = false;

    inherit image;
    base16Scheme = {
      base00 = "#181616"; # Default Background
      base01 = "#0d0c0c"; # Lighter Background (Status bars)
      base02 = "#2d4f67"; # Selection Background (The blue-grey you like)
      base03 = "#a6a69c"; # Comments, Invisibles
      base04 = "#7fb4ca"; # Dark Foreground
      base05 = "#c5c9c5"; # Default Foreground (Text)
      base06 = "#938aa9"; # Light Foreground
      base07 = "#c5c9c5"; # Lightest Foreground

      base08 = "#c4746e"; # Red (Variables/Errors)
      base09 = "#e46876"; # Orange (Constants)
      base0A = "#c4b28a"; # Yellow (Classes)
      base0B = "#8a9a7b"; # Green (Strings)
      base0C = "#8ea4a2"; # Cyan (Regex)
      base0D = "#8ba4b0"; # Blue (Functions)
      base0E = "#a292a3"; # Purple (Keywords)
      base0F = "#7aa89f"; # Brown (Deprecated)
    };
    polarity = "dark";
    targets = {
      bat.enable = true;
      btop.enable = true;
      fish.enable = true;
      ghostty.enable = true;
      gtk.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = true;
      lazygit.enable = true;
      mako.enable = true;
      neovide.fonts.enable = true;
      opencode.enable = true;
      qt.enable = true;
      waybar.fonts.enable = true;
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
        name = "JetBrainsMono Nerd Font Mono";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
      sansSerif = {
        name = "Noto Sans";
        package = pkgs.noto-fonts;
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
        applications = 11;
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

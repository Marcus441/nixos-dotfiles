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

  base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa-dragon.yaml";
in {
  imports = [inputs.stylix.homeModules.stylix];

  home.packages = with pkgs; [
    qt6Packages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum

    # Fonts
    dejavu_fonts
    noto-fonts
    noto-fonts-lgc-plus
    noto-fonts-color-emoji
    font-awesome
    powerline-fonts
    powerline-symbols
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
  ];

  stylix = {
    enable = true;
    autoEnable = false;

    inherit image base16Scheme;
    polarity = "dark";
    targets = {
      gtk.enable = false;
      qt.enable = false;

      bat.enable = true;
      btop.enable = true;
      fish.enable = true;
      ghostty.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = true;
      lazygit.enable = true;
      mako.enable = true;
      opencode.enable = true;
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

  # Manual GTK Configuration
  gtk = {
    enable = true;
    theme = {
      name = "Kanagawa-Dragon-master-Purple-Dark-Dragon";

      package = pkgs.stdenv.mkDerivation {
        pname = "Kanagawa-Dragon";
        version = "master";

        src = pkgs.fetchFromGitHub {
          owner = "Fausto-Korpsvart";
          repo = "Kanagawa-GKT-Theme";
          rev = "master";
          hash = "sha256-UdMoMx2DoovcxSp/zBZ3PRv/Qpj+prd0uPm1gmdak2E=";
        };

        nativeBuildInputs = [
          pkgs.sassc
          pkgs.gtk3
          pkgs.util-linux
        ];

        propagatedUserEnvPkgs = [
          pkgs.gtk-engine-murrine
        ];

        postPatch = ''
          patchShebangs themes/install.sh
        '';

        installPhase = ''
          runHook preInstall

          mkdir -p $out/share/themes

          cd themes

          ./install.sh -d $out/share/themes -t purple --tweaks dragon black

          runHook postInstall
        '';
      };
    };
    gtk4.theme = config.gtk.theme;
  };

  # Manual Qt Configuration
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
}

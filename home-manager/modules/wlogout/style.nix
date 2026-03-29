{
  config,
  pkgs,
  ...
}: let
  inherit
    (config.lib.stylix.colors)
    base00
    base01
    base02
    base03
    base04
    base05
    base06
    base07
    base08
    base09
    base0A
    base0B
    base0C
    base0D
    base0E
    base0F
    ;
  wlogoutPkg = config.programs.wlogout.package;

  coloredIcons = pkgs.runCommand "wlogout-colored-icons" {} ''
    mkdir -p $out

    cp ${wlogoutPkg}/share/wlogout/assets/*.svg $out/

    sed -i 's/<svg/<svg fill="#${base0D}"/g' $out/lock.svg
    sed -i 's/<svg/<svg fill="#${base0C}"/g' $out/logout.svg
    sed -i 's/<svg/<svg fill="#${base0A}"/g' $out/suspend.svg
    sed -i 's/<svg/<svg fill="#${base09}"/g' $out/hibernate.svg
    sed -i 's/<svg/<svg fill="#${base08}"/g' $out/shutdown.svg
    sed -i 's/<svg/<svg fill="#${base0E}"/g' $out/reboot.svg
  '';
in {
  programs.wlogout.style = ''
    * {
      background-image: none;
      transition: all 0.3s cubic-bezier(0.4, 0.0, 0.2, 1);
      font-family: "Ubuntu", "Noto Sans", "Symbols Nerd Font Mono";
      font-weight: bold;
      border-radius: 0;
    }

    window {
      background-color: rgba(0, 0, 0, 0.85);
    }

    button {
      color: #${base05};
      background-color: #${base01};
      outline-style: none;
      border: 3px solid #${base02}; /* Constant border width to prevent shifting */
      margin: 15px;
      padding: 40px;
      font-size: 24px;
      background-repeat: no-repeat;
      background-position: center;
      background-size: 25%;
    }

    button:focus,
    button:active,
    button:hover {
      background-color: #${base01};
      color: #${base07};
    }

    /* SPECIFIC MODULE BORDERS */
    #lock {
      border-bottom-color: #${base0D};
    }
    #lock:hover {
      border-color: #${base0D};
    }

    #logout {
      border-bottom-color: #${base0C};
    }
    #logout:hover {
      border-color: #${base0C};
    }

    #suspend {
      border-bottom-color: #${base0A};
    }
    #suspend:hover {
      border-color: #${base0A};
    }

    #hibernate {
      border-bottom-color: #${base09};
    }
    #hibernate:hover {
      border-color: #${base09};
    }

    #shutdown {
      border-bottom-color: #${base08};
    }
    #shutdown:hover {
      border-color: #${base08};
    }

    #reboot {
      border-bottom-color: #${base0E};
    }
    #reboot:hover {
      border-color: #${base0E};
    }

    /* ICON MAPPING */
    #lock { background-image: url("${coloredIcons}/lock.svg"); }
    #logout { background-image: url("${coloredIcons}/logout.svg"); }
    #suspend { background-image: url("${coloredIcons}/suspend.svg"); }
    #hibernate { background-image: url("${coloredIcons}/hibernate.svg"); }
    #shutdown { background-image: url("${coloredIcons}/shutdown.svg"); }
    #reboot { background-image: url("${coloredIcons}/reboot.svg"); }
  '';
}

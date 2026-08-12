_: {
  flake.modules.homeManager.wleave = [
    (
      {
        config,
        lib,
        ...
      }: let
        inherit (lib.mapAttrs (_: lib.removePrefix "#") config.desktop.colors) base00 base01 base02 base03 base05 base08 base09 base0A base0C base0D base0E;
      in {
        programs.wleave.style = ''
          * {
            font-family: "Inter", "Symbols Nerd Font Mono";
            font-weight: bold;
            transition: none;
            animation: none;
          }
          window {
            background-color: #${base00};
          }
          /* adw-gtk3 gives buttons a radius, a gradient and a shadow.
             None of it survives contact with the flat palette. */
          button {
            color: #${base05};
            background-color: #${base01};
            background-image: none;
            box-shadow: none;
            border: 1px solid #${base02};
            border-radius: 0;
            margin: 15px;
            padding: 40px;
            font-size: 18px;
          }
          button:hover,
          button:focus,
          button:active {
            background-color: #${base02};
            border-color: #${base03};
            background-image: none;
            box-shadow: none;
          }
          #lock     { color: #${base0D}; }
          #logout   { color: #${base0C}; }
          #suspend  { color: #${base0A}; }
          #hibernate { color: #${base09}; }
          #shutdown  { color: #${base08}; }
          #reboot    { color: #${base0E}; }
        '';
      }
    )
  ];
}

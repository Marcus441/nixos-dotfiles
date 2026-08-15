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
        # load-bearing: docs/decisions/sessions.md#wleave-no-anim
        # load-bearing: docs/decisions/sessions.md#wleave-focus
        programs.wleave.style = ''
          * {
            font-family: "Inter", "Symbols Nerd Font Mono";
            font-weight: 600;
            transition: none;
            animation: none;
          }
          window {
            background-color: #${base00};
          }
          button {
            color: #${base05};
            background-color: #${base01};
            background-image: none;
            box-shadow: none;
            border: 2px solid #${base03};
            border-radius: 0;
            margin: 15px;
            padding: 40px;
            font-size: 18px;
          }
          button:hover,
          button:focus,
          button:active {
            background-color: #${base02};
            border-color: #${base0D};
            background-image: none;
            box-shadow: none;
          }
          button label.keybind {
            font-size: 14px;
            opacity: 0.55;
          }
          button:hover label.keybind,
          button:focus label.keybind,
          button:active label.keybind {
            opacity: 1;
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

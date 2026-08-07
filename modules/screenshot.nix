_: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        options.screenshot = {
          screen = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Shell command capturing the whole screen to the clipboard.";
          };

          area = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Shell command capturing a selected region to the clipboard.";
          };
        };
      }
    )
  ];

  flake.modules.homeManager.hyprland = [
    {
      screenshot = {
        screen = "uwsm app -- grimblast --notify --freeze copysave screen";
        area = "uwsm app -- grimblast --notify --freeze copysave area";
      };
    }
  ];

  flake.modules.homeManager.dwl = [
    (
      {pkgs, ...}: let
        grim = "${pkgs.grim}/bin/grim";
        slurp = "${pkgs.slurp}/bin/slurp";
        wlCopy = "${pkgs.wl-clipboard}/bin/wl-copy";
      in {
        screenshot = {
          screen = "${grim} - | ${wlCopy}";
          area = "${grim} -g \"$(${slurp})\" - | ${wlCopy}";
        };
      }
    )
  ];
}

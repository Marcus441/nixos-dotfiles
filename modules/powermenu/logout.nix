_: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        options.logout.command = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Shell command that ends the session.";
        };
      }
    )
  ];

  flake.modules.homeManager.hyprland = [
    {logout.command = "hyprctl dispatch 'hl.dsp.exit()'";}
  ];
}

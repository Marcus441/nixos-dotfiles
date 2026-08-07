_: {
  # The shape of lock.command, for the same reason: a menu offering to end the
  # session must not name one compositor's tool from an aspect that installs no
  # compositor. Empty where no session provides one.
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

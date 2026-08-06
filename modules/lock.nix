_: {
  # Declared for every host, implemented only by Hyprland: swift5's dwl session
  # has no locker at all, which the empty default states rather than hides.
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        options.lock.command = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Shell command that locks the session.";
        };
      }
    )
  ];

  flake.modules.homeManager.hyprland = [
    {lock.command = "loginctl lock-session";}
  ];
}

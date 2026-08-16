_: {
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

  # load-bearing: docs/decisions/sessions.md#dwl-idle-dpms
  flake.modules.homeManager.dwl = [
    {lock.command = "loginctl lock-session";}
  ];
}

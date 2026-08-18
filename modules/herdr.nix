_: {
  flake.modules.homeManager.apps = [
    (
      {pkgs, ...}: {
        programs.herdr = {
          enable = true;

          settings = {
            onboarding = false;

            theme = {
              name = "tokyo-night";
              auto_switch = false;
            };
          };
        };

        # load-bearing: docs/decisions/tui.md#herdr-python
        home.packages = [pkgs.python3Minimal];
      }
    )
  ];
}

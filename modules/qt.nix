{...}: {
  flake.modules.homeManager.suckless = [
    (
      {...}: {
        qt = {
          enable = true;
          platformTheme.name = "adwaita";
          style.name = "adwaita-dark";
        };
      }
    )
  ];
}

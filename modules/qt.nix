_: {
  flake.modules.homeManager.core = [
    {
      qt = {
        enable = true;
        platformTheme.name = "adwaita";
        style.name = "adwaita-dark";
      };
    }
  ];
}

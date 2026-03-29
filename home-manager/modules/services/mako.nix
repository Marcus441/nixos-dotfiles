{
  services.mako = {
    enable = true;

    extraConfig = ''
      default-timeout=10

      [mode=do-not-disturb]
      invisible=true

      [mode=do-not-disturb app-name=notify-send]
      invisible=false
    '';

    settings = {
      anchor = "top-right";
      border-size = 2;
      padding = 10;
      max-icon-size = 32;
      outer-margin = 20;
      width = 420;
      height = 110;
    };
  };
}

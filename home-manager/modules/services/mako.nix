{
  services.mako = {
    enable = true;

    # Directly inject sections or extra lines that don't map cleanly
    extraConfig = ''
      [app-name=Spotify]
      invisible=1

      [mode=do-not-disturb]
      invisible=true

      [mode=do-not-disturb app-name=notify-send]
      invisible=false

      [urgency=critical]
      default-timeout=0
    '';

    settings = {
      anchor = "top-right";
      border-size = 2;
      padding = 10;
      # font = "Liberation Sans 11";
      max-icon-size = 32;
      outer-margin = 20;
      width = 420;
      height = 110;
    };
  };
}

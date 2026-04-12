{
  services.mako = {
    enable = true;

    settings = {
      anchor = "top-right";
      default-timeout = 5000;
      ignore-timeout = false;
      border-size = 2;
      padding = 10;
      max-icon-size = 32;
      outer-margin = 20;
      width = 420;
      height = 110;
    };
    extraConfig = ''
      [app-name=notify-send summary="OCR*"]
      default-timeout=3000

      [summary="*Battery*"]
      default-timeout=20000

      [summary="*screenshot*"]
      default-timeout=5000
    '';
  };
}

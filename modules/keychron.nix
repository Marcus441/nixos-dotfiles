_: {
  flake.modules.nixos.keychron = [
    {
      boot.kernelParams = ["hid_apple.fnmode=2"];

      services.keyd = {
        enable = true;
        keyboards.keychron-k8 = {
          ids = ["05ac:024f"];
          settings.main = {
            leftalt = "leftmeta";
            leftmeta = "leftalt";
            rightalt = "rightmeta";
            rightmeta = "rightalt";
          };
        };
      };
    }
  ];
}

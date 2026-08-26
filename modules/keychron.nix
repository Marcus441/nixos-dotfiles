_: {
  flake.modules.nixos.keychron = [
    {
      # load-bearing: docs/decisions/keyboard.md#k8-windows-toggle-keyd
      boot.kernelParams = ["hid_apple.fnmode=2"];

      services.keyd = {
        enable = true;
        keyboards.keychron-k8 = {
          ids = ["05ac:024f"];
          settings.main = {
            leftalt = "leftmeta";
            leftmeta = "leftalt";
          };
        };
      };
    }
  ];
}

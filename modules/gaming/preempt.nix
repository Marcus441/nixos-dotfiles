_: {
  flake.modules.nixos.gaming = [
    {
      boot.kernelParams = ["preempt=full"];
    }
  ];
}

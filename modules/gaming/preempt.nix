_: {
  flake.modules.nixos.gaming = [
    {
      # load-bearing: docs/decisions/gaming.md#preempt-dynamic
      boot.kernelParams = ["preempt=full"];
    }
  ];
}

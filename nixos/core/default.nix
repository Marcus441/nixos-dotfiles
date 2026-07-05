{
  imports = [
    ../dev # per-host dev tooling, self-gated by the `dev` flag
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./common-packages.nix
    ./env.nix
    ./home-manager.nix
    ./kernel.nix
    ./ly.nix
    ./net.nix
    ./nh.nix
    ./nix.nix
    ./power.nix
    ./timezone.nix
    ./user.nix
    ./zram.nix
  ];
}

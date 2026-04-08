{pkgs}:
pkgs.fetchFromGitHub {
  owner = "Marcus441";
  repo = "walls";
  rev = "b11022653952ac634b0c9af6966c560bb0ef0876";
  hash = "sha256-j10orWJweGnIbG8ZBzukYp82FNDPVne7eoEz2qKQeMM=";

  sparseCheckout = [
    "walled_tiers/4k"
  ];
}

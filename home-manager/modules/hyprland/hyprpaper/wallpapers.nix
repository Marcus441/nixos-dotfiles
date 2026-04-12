{pkgs}:
pkgs.fetchFromGitHub {
  owner = "Marcus441";
  repo = "walls";
  rev = "b11022653952ac634b0c9af6966c560bb0ef0876";
  hash = "sha256-N1bizQeNXzr8ZYBq6T55mbnSec0cUkZVXBDd08yulqI=";

  sparseCheckout = [
    "walled_tiers/4k/abstract"
    "walled_tiers/4k/aerial"
    "walled_tiers/4k/apeiros"
    "walled_tiers/4k/architecture"
    "walled_tiers/4k/basalt"
    "walled_tiers/4k/calm"
    "walled_tiers/4k/centered"
    "walled_tiers/4k/cherry"
    "walled_tiers/4k/chillop"
    "walled_tiers/4k/cold"
    "walled_tiers/4k/decay"
    "walled_tiers/4k/digital"
    "walled_tiers/4k/dreamcore"
    "walled_tiers/4k/fauna"
    "walled_tiers/4k/flowers"
    "walled_tiers/4k/fogsmoke"
    "walled_tiers/4k/gruvbox"
    "walled_tiers/4k/halloween"
    "walled_tiers/4k/industrial"
    "walled_tiers/4k/interior"
    "walled_tiers/4k/Jackb"
    "walled_tiers/4k/lightbulb"
    "walled_tiers/4k/logo"
    "walled_tiers/4k/minimal"
    "walled_tiers/4k/monochrome"
    "walled_tiers/4k/mountain"
    "walled_tiers/4k/nature"
    "walled_tiers/4k/nord"
    "walled_tiers/4k/outrun"
    "walled_tiers/4k/painting"
    "walled_tiers/4k/pixel"
    "walled_tiers/4k/poly"
    "walled_tiers/4k/radium"
    "walled_tiers/4k/retro"
    "walled_tiers/4k/solarized"
    "walled_tiers/4k/spam"
    "walled_tiers/4k/unsorted"
    "walled_tiers/4k/weirdcore"
  ];
}

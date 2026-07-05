{
  # Caches for inputs only the maximal profile consumes: danth is stylix's
  # cache, walker/walker-git cover walker and its elephant backend. Shared
  # caches (nix-community, nvf) stay in nixos/core/nix.nix.
  nix.settings = {
    extra-substituters = [
      "https://danth.cachix.org"
      "https://walker.cachix.org"
      "https://walker-git.cachix.org"
    ];
    extra-trusted-public-keys = [
      "danth.cachix.org-1:1ow3ZHcCp6ujnzcK/FPR0gqMMoWijV9foAPvCliY0bQ="
      "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
      "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
    ];
  };
}

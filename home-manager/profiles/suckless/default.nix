{
  # The lean branch: a minimal bash + foot + dwl session.
  # Deliberately excludes fish, starship and the heavy GUI stack; the shared
  # CLI tooling (fzf, ripgrep, fd, ...) is inherited from ../../core.
  imports = [
    ./bash.nix
    ./dwl.nix
    ./foot.nix
    ./monitors.nix
  ];
}

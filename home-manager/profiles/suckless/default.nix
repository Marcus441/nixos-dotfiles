{
  # The lean branch: a minimal bash + foot + dwl session.
  # Deliberately excludes fish, starship and the heavy GUI stack; the shared
  # CLI tooling (fzf, ripgrep, fd, ...) is inherited from ../../core.
  imports = [
    ./bash.nix
    ./colors.nix
    ./cursor.nix
    ./dwl.nix
    ./font.nix
    ./foot.nix
    ./gtk.nix
    ./mako.nix
    ./monitors.nix
    ./qt.nix
  ];
}

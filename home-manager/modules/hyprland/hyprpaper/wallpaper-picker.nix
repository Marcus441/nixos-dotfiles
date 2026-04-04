{pkgs, ...}: let
  lwalpapers = pkgs.fetchFromGitHub {
    owner = "whoisYoges";
    repo = "lwalpapers";
    rev = "35d131f28ca64b3526b7e85e11a2e45332113f70";
    hash = "sha256-yOlGzctUlN+ymYNy9h1d+lnC2MsUrFSW8t2igmHIhy8=";
  };

  wall-script = pkgs.writeShellScriptBin "way-wall" ''
    current_dir="${lwalpapers}"

    while true; do
      list_cmd=$( {
        if [ "$current_dir" != "${lwalpapers}" ]; then echo "../"; fi
        ${pkgs.fd}/bin/fd . "$current_dir" --max-depth 1 --type d --exec echo "{}/" ;
        ${pkgs.fd}/bin/fd . "$current_dir" --max-depth 1 --type f -e jpg -e png -e webp
      } | ${pkgs.gnused}/bin/sed "s|$current_dir/||" )

      selection=$(echo "$list_cmd" | ${pkgs.walker}/bin/walker --dmenu -p "Browsing: $(basename "$current_dir")")

      [[ -z "$selection" ]] && exit 0

      if [[ "$selection" == "../" ]]; then
        current_dir=$(dirname "$current_dir")
      elif [[ "$selection" == */ ]]; then
        current_dir="$current_dir/''${selection%/}"
      else
        full_path="$current_dir/$selection"
        ${pkgs.hyprland}/bin/hyprctl hyprpaper wallpaper ",$full_path"
        exit 0
      fi
    done
  '';
in {
  home.packages = [wall-script];
}

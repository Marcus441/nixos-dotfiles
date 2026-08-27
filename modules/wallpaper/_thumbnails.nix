{pkgs}: let
  walls = import ./_wallpapers.nix {inherit pkgs;};
in
  pkgs.runCommand "wallpaper-thumbnails" {
    nativeBuildInputs = [pkgs.imagemagick pkgs.jq];
  } ''
    shopt -s nullglob
    entries="$TMPDIR/entries.json"
    for dir in ${walls}/walled_tiers/4k/*/; do
      category=$(basename "$dir")
      mkdir -p "$out/thumbs/$category"
      for img in "$dir"*.jpg "$dir"*.jpeg "$dir"*.png "$dir"*.webp; do
        base=$(basename "$img")
        thumb="$out/thumbs/$category/$base.jpg"
        magick "$img" -auto-orient -resize 240 -strip -quality 82 "$thumb"
        jq -n --arg category "$category" --arg name "''${base%.*}" \
          --arg path "$img" --arg thumb "$thumb" \
          '{$category, $name, $path, $thumb}' >>"$entries"
      done
    done
    jq -s '{categories: (group_by(.category) | map(sort_by(.name) as $w | {
      name: $w[0].category,
      count: ($w | length),
      cover: $w[0].thumb,
      walls: ($w | map({name, path, thumb}))
    }))}' "$entries" >"$out/manifest.json"
  ''

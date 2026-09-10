{
  lib,
  writeShellScriptBin,
  grim,
  slurp,
  wl-clipboard,
  libnotify,
}:
writeShellScriptBin "areashot" ''
  export PATH="$PATH:${lib.makeBinPath [grim slurp wl-clipboard libnotify]}"
  set -o pipefail
  if grim -g "$(slurp)" - | wl-copy --type image/png; then
    notify-send "Area Screenshot Successful" "Image copied to clipboard"
  else
    notify-send -u critical "Area Screenshot Failed" "grim or slurp returned an error"
  fi
''

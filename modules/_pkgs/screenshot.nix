{
  lib,
  writeShellScriptBin,
  grim,
  wl-clipboard,
  libnotify,
}:
writeShellScriptBin "screenshot" ''
  export PATH="$PATH:${lib.makeBinPath [grim wl-clipboard libnotify]}"
  set -o pipefail
  if grim - | wl-copy --type image/png; then
    notify-send "Screenshot Successful" "Image copied to clipboard"
  else
    notify-send -u critical "Screenshot Failed" "grim returned an error"
  fi
''

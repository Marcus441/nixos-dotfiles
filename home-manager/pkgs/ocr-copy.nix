{
  lib,
  writeShellScriptBin,
  grim,
  slurp,
  tesseract,
  wl-clipboard,
  libnotify,
}:
writeShellScriptBin "ocr-copy" ''
  export PATH=$PATH:${lib.makeBinPath [grim slurp tesseract wl-clipboard libnotify]}

  # Select area and capture it using tools compatible with both dwl and Hyprland
  text=$(grim -g "$(slurp)" - | tesseract stdin stdout --psm 6 2>/dev/null)

  if [ -n "$text" ]; then
    echo "$text" | wl-copy
    notify-send "OCR Successful" "Text copied to clipboard"
  else
    notify-send "OCR Failed" "No text detected"
  fi
''

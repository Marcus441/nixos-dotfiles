# OCR-to-clipboard helper shared by the maximal (hyprland) and suckless (dwl)
# sessions: grab a region, run tesseract over it, copy the text and notify.
{
  lib,
  writeShellScriptBin,
  grimblast,
  tesseract,
  wl-clipboard,
  libnotify,
}:
writeShellScriptBin "ocr-copy" ''
  export PATH=$PATH:${lib.makeBinPath [grimblast tesseract wl-clipboard libnotify]}
  text=$(grimblast --freeze save area - | tesseract stdin stdout --psm 6)
  if [ -n "$text" ]; then
    echo "$text" | wl-copy
    notify-send "OCR Successful" "Text copied to clipboard"
  else
    notify-send "OCR Failed" "No text detected"
  fi
''

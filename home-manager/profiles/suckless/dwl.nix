{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.suckless) colors font;

  # #rrggbb -> 0xrrggbbff for dwl's bar colour table.
  toBar = hex: "0x" + lib.toLower (lib.removePrefix "#" hex) + "ff";

  # OCR-to-clipboard helper (mirrors the maximal hyprland binding).
  ocr-copy = pkgs.writeShellScriptBin "ocr-copy" ''
    export PATH=$PATH:${lib.makeBinPath [pkgs.grimblast pkgs.tesseract pkgs.wl-clipboard pkgs.libnotify]}
    text=$(grimblast --freeze save area - | tesseract stdin stdout --psm 6)
    if [ -n "$text" ]; then
      echo "$text" | wl-copy
      notify-send "OCR Successful" "Text copied to clipboard"
    else
      notify-send "OCR Failed" "No text detected"
    fi
  '';

  # The community "bar" user patch (adds an in-compositor status bar).
  barPatch = pkgs.fetchpatch {
    name = "dwl-bar.patch";
    url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/patches/bar/bar.patch";
    hash = "sha256-guW5Gan9jg5S8O7F/LfvQpUJy7Cgs8ly89peL7YazeI=";
  };

  dwl-suckless = pkgs.dwl.overrideAttrs (old: {
    patches = (old.patches or []) ++ [barPatch];
    # The bar patch draws text with fcft/pixman and pulls in libdrm headers.
    buildInputs = (old.buildInputs or []) ++ [pkgs.fcft pkgs.libdrm];

    postPatch =
      (old.postPatch or "")
      + ''
        # --- spawn commands: absolute store paths + the extra programs ---
        substituteInPlace config.def.h \
          --replace-fail 'WLR_MODIFIER_ALT' 'WLR_MODIFIER_LOGO' \
          --replace-fail '"foot", NULL' '"${pkgs.foot}/bin/foot", NULL' \
          --replace-fail '"wmenu-run", NULL };' '"${pkgs.wmenu}/bin/wmenu-run", NULL };
        static const char *shotcmd[]     = { "${pkgs.grimblast}/bin/grimblast", "--notify", "--freeze", "copysave", "screen", NULL };
        static const char *areashotcmd[] = { "${pkgs.grimblast}/bin/grimblast", "--notify", "--freeze", "copysave", "area", NULL };
        static const char *ocrcmd[]      = { "${ocr-copy}/bin/ocr-copy", NULL };'

        # --- bar theme: IosevkaTerm font + base16 Kanagawa Dragon colours ---
        substituteInPlace config.def.h \
          --replace-fail 'monospace:size=10' '${font.name}:size=10' \
          --replace-fail '0xbbbbbbff' '${toBar colors.base05}' \
          --replace-fail '0x222222ff' '${toBar colors.base00}' \
          --replace-fail '0x444444ff' '${toBar colors.base02}' \
          --replace-fail '0xeeeeeeff' '${toBar colors.base06}' \
          --replace-fail '0x005577ff' '${toBar colors.base0D}' \
          --replace-fail '0x770000ff' '${toBar colors.base08}' \
          --replace-fail '0x000000ff' '${toBar colors.base00}'

        # --- keybinds (mirror the hyprland binds, stay near dwl defaults) ---
        # super+enter -> terminal, super+d -> launcher (swaps with the
        # defaults' zoom/incnmaster), plus ocr-copy and screenshots.
        sed -i -E \
          -e 's/(XKB_KEY_)p(,[[:space:]]+spawn,[[:space:]]+\{\.v = menucmd\})/\1d\2/' \
          -e 's/(XKB_KEY_)d(,[[:space:]]+incnmaster,[[:space:]]+\{\.i = -1\})/\1p\2/' \
          -e 's/(MODKEY,[[:space:]]+XKB_KEY_Return,[[:space:]]+)zoom,([[:space:]]+)\{0\}/\1spawn,\2{.v = termcmd}/' \
          -e 's/(MODKEY\|WLR_MODIFIER_SHIFT,[[:space:]]+XKB_KEY_Return,[[:space:]]+)spawn,([[:space:]]+)\{\.v = termcmd\}/\1zoom,\2{0}/' \
          -e 's@(XKB_KEY_c,[[:space:]]+killclient,[[:space:]]+\{0\} \},)@\1\n\t{ MODKEY,                    XKB_KEY_c,           spawn,            {.v = ocrcmd} },\n\t{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_s,           spawn,            {.v = shotcmd} },\n\t{ 0,                         XKB_KEY_Print,       spawn,            {.v = areashotcmd} },@' \
          config.def.h

        # --- assert the rebinds landed (fail loudly otherwise) ---
        grep -q 'XKB_KEY_d,[[:space:]]\+spawn,[[:space:]]\+{.v = menucmd}' config.def.h || { echo "dwl: super+d launcher rebind missing"; exit 1; }
        grep -q 'MODKEY,[[:space:]]\+XKB_KEY_Return,[[:space:]]\+spawn,[[:space:]]\+{.v = termcmd}' config.def.h || { echo "dwl: super+enter terminal rebind missing"; exit 1; }
        grep -q '{.v = ocrcmd}' config.def.h || { echo "dwl: ocr keybind missing"; exit 1; }
        grep -q '{.v = shotcmd}' config.def.h || { echo "dwl: screenshot keybind missing"; exit 1; }
      '';
  });
in {
  # dwl: the pure Wayland successor to dwm, with the bar patch and a small set
  # of keybinds mirroring the maximal hyprland session. Monitor layout is
  # applied at runtime by the compositor-agnostic `dwl-monitors` (./monitors.nix).
  home.packages = [
    dwl-suckless
    pkgs.wmenu # super+d launcher
    pkgs.grimblast # screenshots (super+shift+s / Print)
    pkgs.wl-clipboard
    ocr-copy # super+c
  ];
}

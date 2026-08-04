{
  # Terminal font size for the maximal hosts. The shared default (16, in
  # home-manager/core/font.nix) is sized for the swift5 laptop panel; the
  # desktops ran ghostty at 20 before it was retired in step 1.5, so foot
  # matches that here. The font *family* comes from core/font.nix, the font
  # *packages* from ./stylix.nix.
  suckless.font.size = 20;
}

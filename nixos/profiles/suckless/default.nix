{pkgs, ...}: let
  # dwl is compiled-and-configured in the suckless *home* profile (its config
  # is compile-time), so the session launches the user's ~/.nix-profile copy.
  # Running `home-manager switch` for the suckless profile is therefore a
  # prerequisite -- which you need anyway to get bash/foot/fonts/dwl-monitors.
  dwl-session = pkgs.writeShellScript "dwl-session" ''
    # Make the home-manager profile (dwl, foot, wmenu, dwl-monitors) visible.
    export PATH="$HOME/.nix-profile/bin:$HOME/.local/state/nix/profile/bin:$PATH"
    export XDG_CURRENT_DESKTOP=dwl
    export XDG_SESSION_TYPE=wayland

    # Apply the host monitor layout (compositor-agnostic, from the home profile).
    command -v dwl-monitors >/dev/null 2>&1 && dwl-monitors &

    # dwl reads its bar status from stdin; feed a minimal clock.
    { while :; do date '+%a %d %b  %H:%M'; sleep 30; done; } | dwl
  '';

  dwl-desktop = pkgs.writeTextFile {
    name = "dwl-session";
    destination = "/share/wayland-sessions/dwl.desktop";
    text = ''
      [Desktop Entry]
      Name=dwl
      Comment=dwl (suckless profile)
      Exec=${dwl-session}
      Type=Application
    '';
    passthru.providedSessions = ["dwl"];
  };
in {
  # Register the dwl session with the display manager (ly, from ../../core/ly.nix).
  services.displayManager.sessionPackages = [dwl-desktop];

  # Portals: wlr backend gives screenshot/screencast (grim/pipewire) on any
  # wlroots compositor incl. dwl; gtk backend covers file choosers + settings.
  # The wrapper exports XDG_CURRENT_DESKTOP=dwl, so this `dwl` config applies.
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.dwl = {
      default = ["gtk"];
      "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
      "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
    };
  };
}

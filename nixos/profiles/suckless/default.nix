{
  pkgs,
  lib,
  user,
  ...
}: let
  # dwl is compiled-and-configured in the suckless *home* profile (its config
  # is compile-time), so the session launches the user's ~/.nix-profile copy.
  # Running `home-manager switch` for the suckless profile is therefore a
  # prerequisite -- which you need anyway to get bash/foot/fonts/dwl-monitors.
  dwl-session = pkgs.writeShellScript "dwl-session" ''
    # Load the home-manager session environment (PATH, XDG_DATA_DIRS so that
    # wmenu finds .desktop files and dbus finds the mako service, etc.).
    hm_vars="$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    [ -f "$hm_vars" ] && . "$hm_vars"
    export PATH="$HOME/.nix-profile/bin:$PATH"
    export XDG_CURRENT_DESKTOP=dwl
    export XDG_SESSION_TYPE=wayland

    # dwl's -s autostart runs once the compositor is up (so WAYLAND_DISPLAY is
    # set): apply the host monitor layout, then start the notification daemon.
    # dwl reads its bar status from stdin; feed a minimal clock.
    { while :; do date '+%a %d %b  %H:%M'; sleep 30; done; } | dwl -s 'dwl-monitors; mako &'
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
  # Override core's fish login shell -- the suckless branch is bash (its
  # configured shell lives in the suckless home profile). fish stays installed
  # system-wide via core, this just changes ${user}'s login shell.
  users.users.${user}.shell = lib.mkForce pkgs.bashInteractive;

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

_: let
  uwsmStart = ''
    if uwsm check may-start > /dev/null && uwsm select; then
      uwsm start default | systemd-cat -t uwsm_start
    fi
  '';
in {
  flake.modules.homeManager.hyprland = [
    (
      {pkgs, ...}: {
        # load-bearing: docs/decisions/sessions.md#uwsm-login-shell
        programs.bash.profileExtra = uwsmStart;
        programs.zsh.profileExtra = uwsmStart;

        wayland.windowManager.hyprland = {
          enable = true;
          systemd.enable = false;
          configType = "lua";
          package = null;
          portalPackage = null;
        };

        # load-bearing: docs/decisions/sessions.md#hyprland-luarc
        xdg.configFile."hypr/.luarc.json".text = builtins.toJSON {
          workspace.library = ["${pkgs.hyprland}/share/hypr/stubs"];
          diagnostics.globals = ["hl"];
        };

        home.packages = [pkgs.xdg-desktop-portal-gtk];

        windowTags.floating-window = ["^(xdg-desktop-portal-gtk)$"];
      }
    )
  ];

  flake.modules.nixos.hyprland = [
    {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
      };

      security.pam.services.hyprlock = {};
    }
  ];
}

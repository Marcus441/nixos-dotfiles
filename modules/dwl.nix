_: {
  flake.modules.homeManager.dwl = [
    (
      {lib, ...}: {
        options.dwl = {
          bar = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether the compiled dwl has a bar. Selects which symbols config.h defines: showbar/fonts/tags[]/colors[][3] against upstream's bordercolor/focuscolor/urgentcolor and TAGCOUNT.";
          };

          patches = lib.mkOption {
            type = lib.types.listOf lib.types.path;
            default = [];
            description = "Applied to nixpkgs' dwl before config.h is copied in.";
          };

          buildInputs = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = [];
            description = "Extra buildInputs the patches need.";
          };
        };
      }
    )

    (
      {
        pkgs,
        lib,
        config,
        ...
      }: let
        ocr-copy = pkgs.callPackage ./_pkgs/ocr-copy.nix {};

        configH = pkgs.writeText "dwl-config.h" (import ./_dwl/config-h.nix {
          inherit lib pkgs config ocr-copy;
        });

        dwl-suckless = pkgs.dwl.overrideAttrs (old: {
          patches = (old.patches or []) ++ config.dwl.patches;
          buildInputs = (old.buildInputs or []) ++ config.dwl.buildInputs;

          postPatch =
            (old.postPatch or "")
            + ''
              cp ${configH} config.h
            '';
        });
      in {
        home.packages = [
          dwl-suckless
          pkgs.wl-clipboard
          ocr-copy
          pkgs.grim
          pkgs.slurp
        ];
      }
    )
  ];

  # load-bearing: docs/decisions/sessions.md#dwl-autostart-core
  flake.modules.nixos.core = [
    (
      {lib, ...}: {
        options.dwl.autostart = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "Commands the session backgrounds once the compositor is up, after its own wallpaper and notifier. Resolved from ~/.nix-profile/bin, and run by dwl's -s shell inside single quotes, so an entry may not contain one. Declared here because aspects that are not the session set it; a host without dwl carries it inertly.";
        };
      }
    )
  ];

  flake.modules.nixos.dwl = [
    (
      {lib, ...}: {
        options.dwl.statusCommand = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Shell command whose stdout dwl reads as bar status. Empty when the compositor was built without a bar, in which case the session does not pipe into it at all.";
        };
      }
    )

    (
      {
        pkgs,
        lib,
        config,
        ...
      }: let
        wallpaper = pkgs.fetchFromGitHub {
          owner = "Marcus441";
          repo = "walls";
          rev = "b11022653952ac634b0c9af6966c560bb0ef0876";
          hash = "sha256-ncCvJdy1wCVRdTK/WWnR63kfXw02q0I0xjIQdVM/jvU=";
          sparseCheckout = ["walled_tiers/4k/aerial/satellite_dishes_on_a_building.jpg"];
        };
        wallpaperImage = "${wallpaper}/walled_tiers/4k/aerial/satellite_dishes_on_a_building.jpg";

        statusFeed =
          lib.optionalString (config.dwl.statusCommand != "")
          "{ ${config.dwl.statusCommand}; } | ";

        autostart = lib.concatMapStrings (c: " ${c} &") config.dwl.autostart;

        # load-bearing: docs/decisions/sessions.md#dwl-session
        dwl-session = pkgs.writeShellScript "dwl-session" ''
          # Load the home-manager session environment (PATH, XDG_DATA_DIRS so that
          # wmenu finds .desktop files and dbus finds the mako service, etc.).
          hm_vars="$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
          [ -f "$hm_vars" ] && . "$hm_vars"
          export PATH="$HOME/.nix-profile/bin:$PATH"
          export XDG_CURRENT_DESKTOP=dwl
          export XDG_SESSION_TYPE=wayland

          # -s autostart, once the compositor is up: monitor layout, wallpaper,
          # notifications, then dwl.autostart. Pipe is the status feed.
          ${statusFeed}dwl -s 'dwl-monitors; ${pkgs.swaybg}/bin/swaybg -i ${wallpaperImage} -m fill & mako &${autostart}'
        '';

        dwl-desktop = pkgs.writeTextFile {
          name = "dwl-session";
          destination = "/share/wayland-sessions/dwl.desktop";
          text = ''
            [Desktop Entry]
            Name=dwl
            Comment=dwl
            Exec=${dwl-session}
            Type=Application
          '';
          passthru.providedSessions = ["dwl"];
        };
      in {
        services.displayManager.sessionPackages = [dwl-desktop];

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
    )
  ];
}

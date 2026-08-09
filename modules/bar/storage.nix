_: {
  flake.modules.homeManager.waybar = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }: let
        report = pkgs.writeShellApplication {
          name = "nix-store-report";
          runtimeInputs = with pkgs; [coreutils gawk gnugrep gnused nix];
          text = ''
            # 17 boxed lines: both profiles, and what a collection would free
            W=62

            rule() {
              local i=0 out=""
              while [ "$i" -lt "$1" ]; do
                out+="─"
                i=$((i + 1))
              done
              printf '%s' "$out"
            }

            restore_tty() {
              printf '\033[?25h'
              if [ -t 0 ]; then
                stty echo icanon 2>/dev/null || true
              fi
            }
            trap restore_tty EXIT

            printf '\033[?25l'
            if [ -t 0 ]; then
              stty -echo -icanon 2>/dev/null || true
            fi

            box_top() { printf '┌─ %s %s┐\n' "$1" "$(rule "$((W - 5 - ''${#1}))")"; }
            box_bottom() { printf '└%s┘\n' "$(rule "$((W - 2))")"; }
            row() { printf '│ %-*.*s │\n' "$((W - 4))" "$((W - 4))" "$1"; }
            field() { row "$(printf ' %-18s %s' "$1" "$2")"; }

            closure() {
              local size
              size=$(nix path-info -Sh "$1" 2>/dev/null | awk '{print $2, $3}') || size=""
              printf '%s' "''${size:-unreadable}"
            }

            generations() {
              local links current
              links=("$1"-*-link)
              if [ ! -e "''${links[0]}" ]; then
                printf 'unreadable'
                return
              fi
              current=$(readlink "$1" 2>/dev/null) || current=""
              current=''${current%-link}
              current=''${current##*-}
              printf '%s kept, current is %s' "''${#links[@]}" "''${current:-unknown}"
            }

            system=/nix/var/nix/profiles/system
            home=''${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/home-manager

            box_top "closures"
            field "system" "$(closure "$system")"
            field "home-manager" "$(closure "$home")"
            field "store filesystem" "$(df -h /nix/store | awk 'NR==2 {print $3 " of " $2 " (" $5 ")"}')"
            box_bottom
            echo

            box_top "generations"
            field "system" "$(generations "$system")"
            field "home-manager" "$(generations "$home")"
            box_bottom
            echo

            printf '  measuring...\r'
            gc=$(nix-collect-garbage --delete-older-than 30d --dry-run 2>&1) || gc=""
            printf '               \r'

            profiles=$(printf '%s\n' "$gc" | sed -n 's|.*old generations of profile .*/||p' |
              awk '{list = list (NR > 1 ? ", " : "") $0} END {print list}')
            dead=$(printf '%s\n' "$gc" | grep -oE '[0-9]+ store paths would be deleted') || dead=""

            box_top "a 30-day collection (dry run)"
            field "old generations" "''${profiles:-none}"
            row " ''${dead:-nothing would be deleted}"
            box_bottom

            echo "  nothing was deleted. system generations need root to appear above."
            while read -rsn 1 -t 0.01 _; do :; done
            read -rsn 1 -p "  press any key to close"
            echo
          '';
        };
      in {
        programs.waybar.settings.mainBar.disk = {
          interval = 60;
          path = "/";
          format = "󰋊 {percentage_used}%";
          tooltip-format = "{used} of {total} used ({free} free)";
          states = {
            warning = 80;
            critical = 90;
          };
          on-click = "uwsm app -- ${
            lib.escapeShellArgs (
              config.terminal.transientArgv ++ ["${report}/bin/nix-store-report"]
            )
          }";
        };
      }
    )
  ];
}

{
  config,
  pkgs,
  ...
}: let
  lwalpapers = pkgs.fetchFromGitHub {
    owner = "whoisYoges";
    repo = "lwalpapers";
    rev = "35d131f28ca64b3526b7e85e11a2e45332113f70";
    hash = "sha256-yOlGzctUlN+ymYNy9h1d+lnC2MsUrFSW8t2igmHIhy8=";
  };
in {
  xdg.configFile."elephant/menus/wallpapers.lua".text = ''
    Name = "wallpapers"
    NamePretty = "Wallpapers"
    Icon = "preferences-desktop-wallpaper"
    Cache = true
    FixedOrder = true

    Action = "${pkgs.writeShellScript "wp-logic" ''
      if [ "$1" = "ENABLE_ROTATOR" ]; then
        ${pkgs.systemd}/bin/systemctl --user restart wallpaper-rotator.service
      else
        ${pkgs.systemd}/bin/systemctl --user stop wallpaper-rotator.service
        ${pkgs.hyprland}/bin/hyprctl hyprpaper wallpaper ",$1"
      fi
    ''} \"%VALUE%\""

    function GetEntries()
        local entries = {}
        local wallpaper_dir = "${lwalpapers}"

        table.insert(entries, {
            Text = "🎲 Random / Enable Rotator",
            Subtext = "Starts the automatic wallpaper-rotator service",
            Value = "ENABLE_ROTATOR",
            Icon = "media-playlist-shuffle"
        })

        local file_list = {}
        local cmd = "${pkgs.fd}/bin/fd -t f -e jpg -e jpeg -e png -e webp . '" .. wallpaper_dir .. "' 2>/dev/null"
        local handle = io.popen(cmd)

        if handle then
            for line in handle:lines() do
                table.insert(file_list, line)
            end
            handle:close()
        end

        table.sort(file_list)

        for _, line in ipairs(file_list) do
            local filename = line:match("([^/]+)$")
            if filename then
                local parent_dir = line:match("([^/]+)/[^/]+$") or "Root"
                local clean_name = filename:match("(.+)%.") or filename
                local number_prefix = filename:match("(%d+%.)")
                local display_name = number_prefix or clean_name

                table.insert(entries, {
                    Text = parent_dir .. "  /  " .. display_name,
                    Subtext = "Manual Selection (Stops Rotator)",
                    Keywords = { parent_dir, clean_name },
                    Value = line,
                    Preview = line,
                    PreviewType = "file"
                })
            end
        end

        return entries
    end
  '';
}

{pkgs, ...}: let
  walls = import ./wallpapers.nix {inherit pkgs;};
  update-wallpaper = pkgs.writeShellScript "update-wallpaper" ''
    if [ -f "$1" ]; then
      ln -sf "$1" "$HOME/.cache/current_wallpaper.img"
      ${pkgs.hyprland}/bin/hyprctl hyprpaper wallpaper ",$1"
    fi
  '';
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
        ${pkgs.libnotify}/bin/notify-send -u low -i media-playlist-shuffle "Wallpaper Rotator" "Automatic rotation enabled"
      else
        ${pkgs.systemd}/bin/systemctl --user stop wallpaper-rotator.service
        ${update-wallpaper} "$1"
        ${pkgs.libnotify}/bin/notify-send -u low -i media-playback-stop "Wallpaper Rotator" "Manual mode: Rotation disabled"
      fi
    ''} \"%VALUE%\""

    function GetEntries()
        local entries = {}
        local wallpaper_dir = "${walls}"

        local function to_normal_case(str)
            local s = str:gsub("[_%-]", " ")
            return (s:gsub("(%a)([%w']*)", function(first, rest)
                return first:upper() .. rest:lower()
            end))
        end

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
            for line in handle:lines() do table.insert(file_list, line) end
            handle:close()
        end
        table.sort(file_list)

        for _, line in ipairs(file_list) do
            local filename = line:match("([^/]+)$")
            if filename then
                local parent_raw = line:match("([^/]+)/[^/]+$") or "Root"
                local clean_raw = filename:match("(.+)%.") or filename
                local display_parent = to_normal_case(parent_raw)
                local display_name = to_normal_case(clean_raw)

                table.insert(entries, {
                    Text = display_parent .. "  /  " .. display_name,
                    Keywords = { parent_raw, clean_raw, display_name },
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

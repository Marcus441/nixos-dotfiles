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

    Action = "${pkgs.hyprland}/bin/hyprctl hyprpaper wallpaper \",%VALUE%\""

    function GetEntries()
        local entries = {}
        local wallpaper_dir = "${lwalpapers}"

        local cmd = "${pkgs.fd}/bin/fd -t f -e jpg -e jpeg -e png -e webp . '" .. wallpaper_dir .. "' 2>/dev/null"
        local handle = io.popen(cmd)

        if handle then
            for line in handle:lines() do
                local filename = line:match("([^/]+)$")

                if filename then
                    local parent_dir = line:match("([^/]+)/[^/]+$") or "Root"
                    local clean_name = filename:match("(.+)%.") or filename
                    local number_prefix = filename:match("(%d+%.)")
                    local display_name = number_prefix or clean_name

                    table.insert(entries, {
                        Text = parent_dir .. "  /  " .. display_name,
                        Subtext = "Hyprpaper",
                        Keywords = { parent_dir, clean_name },
                        Value = line,
                        Preview = line,
                        PreviewType = "file"
                    })
                end
            end
            handle:close()
        end

        return entries
    end
  '';
}

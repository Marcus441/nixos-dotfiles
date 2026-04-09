{
  pkgs,
  config,
  ...
}: let
  dragonBg = "181616"; # dragonBlack3
  dragonFg = "c5c9c5"; # dragonWhite
  dragonGray = "7a8382"; # dragonGray3
  dragonSelBg = "282727"; # dragonBlack4
  dragonSelFg = "c4b28a"; # dragonYellow

  dragonRed = "c4746e";
  dragonOrange = "b6927b";
  dragonYellow = "c4b28a";
  dragonGreen = "87a987";
  dragonGreen2 = "8a9a7b";
  dragonAqua = "8ea4a2";
  dragonBlue = "8ba4b0";
  dragonViolet = "8992a7";
  dragonPink = "a292a3";
  dragonTeal = "949fb5";
in {
  programs.btop = {
    enable = true;
    package = pkgs.btop.override {
      rocmSupport = true;
      cudaSupport = true;
    };
    settings = {
      color_theme = "kanagawa-dragon";
      cpu_sensor = "auto";
      io_graph_combined = false;
      io_mode = true;
      only_physical = true;
      proc_tree = true;
      rounded_corners = true;
      show_coretemp = true;
      show_disks = true;
      show_gpu_info = "on";
      show_uptime = true;
      theme_background = false;
      update_ms = 500;
      truecolor = true;
      graph_symbol = "braille";
      vim_keys = true;
    };
  };

  xdg.configFile."btop/themes/kanagawa-dragon.theme".text = ''
    # Bashtop Kanagawa-dragon (https://github.com/rebelot/kanagawa.nvim) theme
    # By: Marcus441

    # Main bg
    theme[main_bg]="#${dragonBg}"

    # Main text color
    theme[main_fg]="#${dragonFg}"

    # Title color for boxes
    theme[title]="#${dragonFg}"

    # Highlight color for keyboard shortcuts
    theme[hi_fg]="#${dragonRed}"

    # Background color of selected item in processes box
    theme[selected_bg]="#${dragonSelBg}"

    # Foreground color of selected item in processes box
    theme[selected_fg]="#${dragonSelFg}"

    # Color of inactive/disabled text
    theme[inactive_fg]="#${dragonGray}"

    # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
    theme[proc_misc]="#${dragonAqua}"

    # Cpu box outline color
    theme[cpu_box]="#${dragonGray}"

    # Memory/disks box outline color
    theme[mem_box]="#${dragonGray}"

    # Net up/down box outline color
    theme[net_box]="#${dragonGray}"

    # Processes box outline color
    theme[proc_box]="#${dragonGray}"

    # Box divider line and small boxes line color
    theme[div_line]="#${dragonGray}"

    # Temperature graph colors
    theme[temp_start]="#${dragonGreen2}"
    theme[temp_mid]="#${dragonOrange}"
    theme[temp_end]="#${dragonRed}"

    # CPU graph colors
    theme[cpu_start]="#${dragonGreen}"
    theme[cpu_mid]="#${dragonYellow}"
    theme[cpu_end]="#${dragonRed}"

    # Mem/Disk free meter
    theme[free_start]="#${dragonRed}"
    theme[free_mid]="#${dragonPink}"
    theme[free_end]="#${dragonRed}"

    # Mem/Disk cached meter
    theme[cached_start]="#${dragonGreen2}"
    theme[cached_mid]="#${dragonOrange}"
    theme[cached_end]="#${dragonOrange}"

    # Mem/Disk available meter
    theme[available_start]="#${dragonViolet}"
    theme[available_mid]="#${dragonTeal}"
    theme[available_end]="#${dragonBlue}"

    # Mem/Disk used meter
    theme[used_start]="#${dragonBlue}"
    theme[used_mid]="#${dragonTeal}"
    theme[used_end]="#${dragonAqua}"

    # Download graph colors
    theme[download_start]="#${dragonTeal}"
    theme[download_mid]="#${dragonViolet}"
    theme[download_end]="#${dragonPink}"

    # Upload graph colors
    theme[upload_start]="#${dragonOrange}"
    theme[upload_mid]="#${dragonYellow}"
    theme[upload_end]="#${dragonRed}"

    # Process box color gradient for threads, mem and cpu usage
    theme[process_start]="#${dragonGreen}"
    theme[process_mid]="#${dragonYellow}"
    theme[process_end]="#${dragonRed}"
  '';
}

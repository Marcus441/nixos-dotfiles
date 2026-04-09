{
  pkgs,
  config,
  ...
}: let
  inherit
    (config.lib.stylix.colors)
    base00
    base01
    base02
    base03
    base04
    base05
    base06
    base07
    base08
    base09
    base0A
    base0B
    base0C
    base0D
    base0E
    base0F
    ;
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
      rounded_corners = false;
      show_coretemp = true;
      show_disks = true;
      show_gpu_info = "on";
      show_uptime = true;
      update_ms = 500;
      truecolor = true;
      graph_symbol = "braille";
      vim_keys = true;
    };
  };

  xdg.configFile."btop/themes/kanagawa-dragon.theme".text = ''
    # Bashtop Kanagawa-dragon (Base16 Refactored)
    # Ported to Base16 Stylix scheme

    # Main bg
    theme[main_bg]="#${base00}"

    # Main text color
    theme[main_fg]="#${base05}"

    # Title color for boxes
    theme[title]="#${base05}"

    # Highlight color for keyboard shortcuts
    theme[hi_fg]="#${base08}"

    # Background color of selected item in processes box
    theme[selected_bg]="#${base02}"

    # Foreground color of selected item in processes box
    theme[selected_fg]="#${base0A}"

    # Color of inactive/disabled text
    theme[inactive_fg]="#${base03}"

    # Misc colors for processes box
    theme[proc_misc]="#${base0C}"

    # Box outline colors
    theme[cpu_box]="#${base03}"
    theme[mem_box]="#${base03}"
    theme[net_box]="#${base03}"
    theme[proc_box]="#${base03}"
    theme[div_line]="#${base03}"

    # Temperature graph colors
    theme[temp_start]="#${base0B}"
    theme[temp_mid]="#${base09}"
    theme[temp_end]="#${base08}"

    # CPU graph colors
    theme[cpu_start]="#${base0B}"
    theme[cpu_mid]="#${base0A}"
    theme[cpu_end]="#${base08}"

    # Mem/Disk free meter
    theme[free_start]="#${base08}"
    theme[free_mid]="#${base0E}"
    theme[free_end]="#${base08}"

    # Mem/Disk cached meter
    theme[cached_start]="#${base0B}"
    theme[cached_mid]="#${base09}"
    theme[cached_end]="#${base09}"

    # Mem/Disk available meter
    theme[available_start]="#${base0F}"
    theme[available_mid]="#${base06}"
    theme[available_end]="#${base0D}"

    # Mem/Disk used meter
    theme[used_start]="#${base0D}"
    theme[used_mid]="#${base06}"
    theme[used_end]="#${base0C}"

    # Download graph colors
    theme[download_start]="#${base04}"
    theme[download_mid]="#${base0F}"
    theme[download_end]="#${base0E}"

    # Upload graph colors
    theme[upload_start]="#${base09}"
    theme[upload_mid]="#${base0A}"
    theme[upload_end]="#${base08}"

    # Process box color gradient
    theme[process_start]="#${base0B}"
    theme[process_mid]="#${base0A}"
    theme[process_end]="#${base08}"
  '';
}

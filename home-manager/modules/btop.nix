{pkgs, ...}: {
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
}

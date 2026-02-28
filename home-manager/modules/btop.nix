{pkgs, ...}: {
  programs.btop = {
    enable = true;
    package = pkgs.btop.override {
      rocmSupport = true;
      cudaSupport = true;
    };
    settings = {
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
      update_ms = 1000;
      vim_keys = true;
    };
  };
}

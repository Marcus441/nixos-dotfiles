_: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        options.systemMonitor.command = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Command opening a system monitor, bare of any session launcher prefix. Empty when no aspect provides one.";
        };
      }
    )
  ];

  flake.modules.homeManager.apps = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }: let
        btop = pkgs.btop.override {
          rocmSupport = true;
          cudaSupport = true;
        };
      in {
        systemMonitor.command = lib.escapeShellArgs (
          config.terminal.compactArgv ++ config.terminal.exec ++ ["${btop}/bin/btop"]
        );

        programs.btop = {
          enable = true;
          package = btop;
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
    )
  ];
}

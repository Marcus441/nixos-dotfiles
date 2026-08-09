_: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        options.systemMonitor = {
          command = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Command opening a system monitor on its processor view, bare of any session launcher prefix. Empty when no aspect provides one.";
          };

          memoryCommand = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "`command`, opening on the memory view instead. Empty when no aspect provides one.";
          };
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

        atPreset = id:
          lib.escapeShellArgs (
            config.terminal.compactArgv ++ ["${btop}/bin/btop" "--preset" id]
          );
      in {
        systemMonitor = {
          command = atPreset "1";
          memoryCommand = atPreset "2";
        };

        programs.btop = {
          enable = true;
          package = btop;
          settings = {
            color_theme = "kanagawa-dragon";
            cpu_sensor = "auto";
            io_graph_combined = false;
            io_mode = true;
            only_physical = true;
            # load-bearing: docs/decisions/terminal.md#btop-presets
            presets = "cpu:0:default,proc:0:default mem:0:default,proc:0:default";
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

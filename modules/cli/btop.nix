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

          temperatureCommand = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "`command`, opening on the temperature view instead. Empty when no aspect provides one.";
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

        toConf = lib.generators.toKeyValue {
          mkKeyValue = lib.generators.mkKeyValueDefault {
            mkValueString = v:
              if lib.isBool v
              then
                (
                  if v
                  then "True"
                  else "False"
                )
              else if lib.isString v
              then ''"${v}"''
              else toString v;
          } " = ";
        };

        # load-bearing: docs/decisions/tui.md#btop-views
        atView = name: overrides: let
          conf = pkgs.writeText "btop-${name}.conf" (
            toConf (settings // {save_config_on_exit = false;} // overrides)
          );
        in
          lib.escapeShellArgs (
            config.terminal.compactArgv ++ config.terminal.exec ++ ["${btop}/bin/btop" "--config" "${conf}"]
          );
      in {
        systemMonitor = {
          command = atView "processor" {
            shown_boxes = "cpu proc";
            proc_sorting = "cpu direct";
            proc_tree = false;
          };

          memoryCommand = atView "memory" {
            shown_boxes = "mem proc";
            proc_sorting = "memory";
            proc_tree = false;
          };

          temperatureCommand = atView "temperature" {
            shown_boxes = "cpu";
          };
        };

        programs.btop = {
          enable = true;
          package = btop;
          inherit settings;
        };
      }
    )
  ];
}

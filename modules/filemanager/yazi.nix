_: {
  flake.modules.homeManager.yazi = [
    (
      {
        config,
        lib,
        ...
      }: let
        argv =
          config.terminal.transientArgv ++ config.terminal.exec ++ ["${config.programs.yazi.finalPackage}/bin/yazi"];

        # load-bearing: docs/decisions/terminal.md#yazi-command
        command = lib.escapeShellArgs argv;

        # load-bearing: docs/decisions/terminal.md#desktop-exec
        desktopArg = a:
          if builtins.match "[a-zA-Z0-9,._+:@%/=-]+" a != null
          then a
          else ''"${lib.escape ["\"" "`" "$" "\\"] a}"'';
        desktopExec = lib.concatMapStringsSep " " desktopArg argv;
      in {
        fileManager.command = command;

        xdg = {
          desktopEntries.yazi = {
            name = "Yazi";
            genericName = "File Manager";
            icon = "system-file-manager";
            exec = "${desktopExec} %f";
            terminal = false;
            startupNotify = false;
            categories = ["System" "FileTools" "FileManager"];
            mimeType = ["inode/directory"];
          };

          mimeApps.defaultApplications."inode/directory" = "yazi.desktop";
        };
      }
    )
  ];

  # load-bearing: docs/decisions/terminal.md#yazi-requires
  aspectRequires.yazi = ["apps"];

  flake.modules.homeManager.apps = [
    (
      {pkgs, ...}: {
        programs.yazi = {
          enable = true;
          shellWrapperName = "y";

          settings = {
            plugin = {
              prepend_fetchers = [
                {
                  url = "*";
                  run = "git";
                  group = "git";
                }
                {
                  url = "*/";
                  run = "git";
                  group = "git";
                }
              ];
            };
          };

          plugins = {
            inherit (pkgs.yaziPlugins) git;
          };

          initLua = ''
            require("git"):setup()
          '';
        };
      }
    )
  ];
}

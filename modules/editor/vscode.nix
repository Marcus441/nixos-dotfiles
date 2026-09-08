_: {
  aspectRequires.vscode = ["dev"];

  flake.modules.darwin.vscode = [
    {
      homebrew.casks = ["visual-studio-code"];
      homebrew.vscode = [
        "ms-dotnettools.csdevkit"
        "ms-dotnettools.csharp"
        "ms-dotnettools.vscode-dotnet-runtime"
        "csharpier.csharpier-vscode"
        "tintoy.msbuild-project-tools"
        "editorconfig.editorconfig"
        "mkhl.direnv"
        "ms-vscode-remote.remote-containers"
        "ms-azuretools.vscode-containers"
        "humao.rest-client"
        "eamodio.gitlens"
        "qufiwefefwoyn.kanagawa"
      ];
    }
  ];

  flake.modules.homeManager.vscode = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }: let
        inherit (config.desktop) font;

        settings = {
          "editor.fontFamily" = font.name;
          "editor.fontSize" = font.terminalSize;
          "editor.fontLigatures" = font.ligatures;
          "workbench.colorTheme" = "Kanagawa";

          "editor.formatOnSave" = true;
          "editor.inlayHints.enabled" = "onUnlessPressed";
          "files.exclude" = {
            "**/bin" = true;
            "**/obj" = true;
          };

          "[csharp]"."editor.defaultFormatter" = "csharpier.csharpier-vscode";
          "dotnet.backgroundAnalysis.analyzerDiagnosticsScope" = "fullSolution";
          "dotnet.backgroundAnalysis.compilerDiagnosticsScope" = "fullSolution";
          "dotnet.formatting.organizeImportsOnFormat" = true;
          "dotnet.inlayHints.enableInlayHintsForParameters" = true;
          "csharp.inlayHints.enableInlayHintsForTypes" = true;

          "direnv.restart.automatic" = true;
        };

        # load-bearing: docs/decisions/darwin.md#vscode-settings-path
        path =
          if pkgs.stdenv.hostPlatform.isDarwin
          then "Library/Application Support/Code/User/settings.json"
          else "${lib.removePrefix "${config.home.homeDirectory}/" config.xdg.configHome}/Code/User/settings.json";
      in {
        home.file.${path}.text = builtins.toJSON settings;
      }
    )
  ];
}

_: {
  flake.modules.homeManager.apps = [
    (
      {
        config,
        lib,
        ...
      }: let
        inherit (config.desktop) colors;

        # load-bearing: docs/decisions/theming.md#fastfetch-rules
        width = 56;
        dash = n: lib.concatStrings (lib.genList (_: "─") n);

        open = name: {
          type = "custom";
          format = "╭─ ${name} ${dash (width - 4 - lib.stringLength name)}";
          outputColor = colors.base03;
        };

        close = {
          type = "custom";
          format = "╰${dash (width - 1)}";
          outputColor = colors.base03;
        };

        row = keyColor: icon: label: rest:
          rest
          // {
            key = "│  ${icon} ${label}";
            inherit keyColor;
          };

        sys = row colors.base0D;
        ses = row colors.base0E;
        hw = row colors.base0B;
      in {
        programs.fastfetch = {
          enable = true;

          settings = {
            logo = {
              source = ''
                        $1██      $2███  ██
                        $1███      $2██████
                         $1███      $2██████
                     $1█████████████ $2████
                    $1███████████████ $2███    $1
                                       $2███  $1██
                        $2███           $2██ $1███
                       $2███             $2 $1███
                $2█████████                $1████████
                $2████████                $1█████████
                    $2███ $1             $1███
                   $2███ $1██           $1███
                   $2██  $1███
                    $2    $1███ $2███████████████
                          $1████ $2█████████████
                         $1██████      $2███
                        $1██████      $2███
                        $1██  ███      $2██ '';
              type = "data";
              color = {
                "1" = colors.base16;
                "2" = colors.base0D;
              };
              padding = {
                top = 1;
                right = 6;
                left = 2;
              };
            };

            display = {
              separator = "  ";
              key.width = 16;

              bar = {
                char = {
                  elapsed = "━";
                  total = "─";
                };
                border = {
                  left = "";
                  right = "";
                };
                width = 10;
                color.total = colors.base02;
              };

              percent = {
                # load-bearing: docs/decisions/theming.md#fastfetch-percent-type
                type = 11;
                color = {
                  green = colors.base0B;
                  yellow = colors.base0A;
                  red = colors.base08;
                };
              };
            };

            modules = [
              "break"
              {
                type = "title";
                format = "{user-name-colored}{at-symbol-colored}{host-name-colored}";
                color = {
                  user = colors.base0A;
                  at = colors.base03;
                  host = colors.base0C;
                };
              }
              "break"

              (open "system")
              (sys "" "os" {type = "os";})
              (sys "" "kernel" {type = "kernel";})
              (sys "󰔚" "uptime" {type = "uptime";})
              (sys "󰏖" "packages" {type = "packages";})
              close

              (open "session")
              (ses "" "wm" {type = "wm";})
              (ses "" "shell" {type = "shell";})
              (ses "" "terminal" {type = "terminal";})
              close

              (open "hardware")
              (hw "󰍛" "cpu" {type = "cpu";})
              (hw "󰢮" "gpu" {type = "gpu";})
              (hw "" "memory" {
                type = "memory";
                format = "{used} / {total}  {percentage-bar}  {percentage}";
              })
              (hw "󰋊" "disk" {
                type = "disk";
                folders = "/";
                format = "{size-used} / {size-total}  {size-percentage-bar}  {size-percentage}";
              })
              close

              "break"
              {
                type = "colors";
                block.width = 2;
                paddingLeft = 3;
              }
            ];
          };
        };
      }
    )
  ];
}

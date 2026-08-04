{
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
        padding = {
          top = 1;
          right = 6;
          left = 2;
        };
      };

      display = {
        separator = "  ";
        key.width = 22;
      };

      modules = [
        "break"
        "title"
        {
          type = "custom";
          format = "────────────────────────────────────────────────";
          outputColor = "white";
        }

        {
          type = "os";
          key = " OS";
          keyColor = "blue";
        }
        {
          type = "kernel";
          key = " Kernel";
          keyColor = "blue";
        }
        {
          type = "uptime";
          key = "󰔚 Uptime";
          keyColor = "blue";
        }
        {
          type = "packages";
          key = "󰏖 Packages";
          keyColor = "blue";
        }

        "break"

        # --- Environment (Magenta) ---
        {
          type = "shell";
          key = " Shell";
          keyColor = "magenta";
        }
        {
          type = "wm";
          key = " WM";
          keyColor = "magenta";
        }
        {
          type = "terminal";
          key = " Terminal";
          keyColor = "magenta";
        }

        "break"

        # --- Hardware (Green) ---
        {
          type = "cpu";
          key = " CPU";
          keyColor = "green";
        }
        {
          type = "gpu";
          key = "󰢮 GPU";
          keyColor = "green";
        }
        {
          type = "memory";
          key = " Memory";
          keyColor = "green";
        }

        "break"
        {
          type = "colors";
        }
      ];
    };
  };
}

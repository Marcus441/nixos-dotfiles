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
      };

      display = {
        separator = "  ";
        key = {
          width = 12;
        };
      };

      modules = [
        "title"
        {
          type = "custom";
          format = "──────────────────────────────";
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

        # --- Hardware (Yellow/Green) ---
        {
          type = "cpu";
          key = " CPU";
          keyColor = "yellow";
        }
        {
          type = "gpu";
          key = "󰢮 GPU";
          keyColor = "yellow";
        }
        {
          type = "memory";
          key = " Memory";
          keyColor = "yellow";
        }

        "break"
        {
          type = "colors";
          symbol = "circle";
        }
      ];
    };
  };
}

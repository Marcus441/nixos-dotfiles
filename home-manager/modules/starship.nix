{
  programs.starship = {
    enable = true;
    enableInteractive = false; # may break some commands
    enableTransience = true;

    settings = {
      character = {
        error_symbol = "[✗](bold red)";
        success_symbol = "[❯](bold green)";
      };
      aws = {
        symbol = " ";
        format = "\\[[$symbol($profile)(\\($region\\))(\\[$duration\\])]($style)\\]";
      };
      buf = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      bun = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      c = {
        symbol = " ";
        format = "\\[[$symbol($version(-$name))]($style)\\]";
      };
      cpp = {
        symbol = " ";
        format = "\\[[$symbol($version(-$name))]($style)\\]";
      };
      cmake = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      cmd_duration = {format = "\\[[ ($duration)]($style)\\]";};
      conda = {
        symbol = " ";
        format = "\\[[$symbol$environment]($style)\\]";
      };
      crystal = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      dart = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      deno = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      directory = {
        read_only = " 󰌾";
      };
      docker_context = {
        symbol = " ";
        format = "\\[[$symbol$context]($style)\\]";
      };
      elixir = {
        symbol = " ";
        format = "\\[[$symbol($version \\(OTP $otp_version\\))]($style)\\]";
      };
      elm = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      fennel = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      fossil_branch = {
        symbol = " ";
        format = "\\[[$symbol$branch]($style)\\]";
      };
      gcloud = {
        symbol = " ";
        format = "\\[[$symbol$account(@$domain)(\\($region\\))]($style)\\]";
      };
      git_branch = {
        symbol = " ";
        format = "\\[[$symbol$branch]($style)\\]";
      };
      git_commit = {
        tag_symbol = "  ";
        format = "\\[[$tag_symbol$commit_hash]($style)\\]";
      };
      git_status = {
        format = "\\[[$all_status]($style)\\]";
        ahead = "⇡$\{count} ";
        diverged = "⇕⇡$\{ahead_count}⇣$\{behind_count} ";
        behind = "⇣$\{count} ";
        conflicted = "";
        up_to_date = "";
        untracked = "?";
        modified = "";
        staged = "";
        renamed = "➜";
        deleted = "";
        stashed = "⚑";
      };
      golang = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      guix_shell = {
        symbol = " ";
        format = "\\[[$symbol]($style)\\]";
      };
      haskell = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      haxe = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      helm = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      hg_branch = {
        symbol = " ";
        format = "\\[[$symbol$branch]($style)\\]";
      };
      java = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      julia = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      kotlin = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      kubernetes = {
        symbol = " ";
        format = "\\[[$symbol$context( \\($namespace\\))]($style)\\]";
      };
      lua = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      memory_usage = {
        symbol = "󰍛 ";
        format = "\\[[$symbol[$ram( | $swap)]]($style)\\]";
      };
      meson = {
        symbol = "󰔷 ";
        format = "\\[[$symbol$project]($style)\\]";
      };
      nim = {
        symbol = "󰆥 ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      nix_shell = {
        symbol = " ";
        format = "\\[[$symbol$state( \\($name\\))]($style)\\]";
      };
      nodejs = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      ocaml = {
        symbol = " ";
        format = "\\[[$symbol($version)(\\($switch_indicator$switch_name\\))]($style)\\]";
      };
      package = {
        symbol = "󰏗 ";
        format = "\\[[$symbol$version]($style)\\]";
      };
      perl = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      php = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      pijul_channel = {
        symbol = " ";
        format = "\\[[$symbol$channel]($style)\\]";
      };
      pixi = {
        symbol = "󰏗 ";
        format = "\\[[$symbol$version( $environment)]($style)\\]";
      };
      python = {
        symbol = " ";
        format = "\\[[$symbol$pyenv_prefix($version)(\\($virtualenv\\))]($style)\\]";
      };
      ruby = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      rust = {
        symbol = "󱘗 ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      scala = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      swift = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      terraform = {
        symbol = " ";
        format = "\\[[$symbol$workspace]($style)\\]";
      };
      zig = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      gradle = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };

      os = {
        symbols = {
          NixOS = " ";
        };
      };
    };
  };
}

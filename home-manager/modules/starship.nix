{
  programs.starship = {
    enable = true;
    enableTransience = true;

    settings = {
      add_newline = false;
      character = {
        error_symbol = "[✗](bold red)";
        success_symbol = "[➜](bold green)";
      };
      # ==============================================
      # ====================Useful====================
      # ==============================================
      os = {
        symbols = {
          NixOS = "  ";
        };
      };
      aws = {
        symbol = "  ";
        format = "\\[[$symbol($profile )(\\($region\\) )(\\[$duration\\] )]($style)\\]";
      };
      c = {
        symbol = "  ";
        format = "\\[[$symbol($version(-$name) )]($style)\\]";
      };
      cpp = {
        symbol = "  ";
        format = "\\[[$symbol($version(-$name) )]($style)\\]";
      };
      cmake = {
        symbol = "  ";
        format = "\\[[$symbol($version )]($style)\\]";
      };
      cmd_duration = {format = "\\[[  ($duration )]($style)\\]";};
      directory = {
        read_only = " 󰌾";
      };
      docker_context = {
        symbol = "  ";
        format = "\\[[$symbol($context )]($style)\\]";
      };
      git_branch = {
        symbol = "  ";
        format = "\\[[$symbol($branch )]($style)\\]";
      };
      git_commit = {
        tag_symbol = "  ";
        format = "\\[[$tag_symbol $commit_hash ]($style)\\]";
      };
      git_status = {
        format = "\\[[[( ($conflicted )($untracked )($modified )($staged )($renamed )($deleted )[|]())]($style)(( $ahead_behind)( $stashed) )]($style)\\]";
        ahead = "⇡$\{count}";
        behind = "⇣$\{count}";
        diverged = "⇕⇡$\{ahead_count}⇣$\{behind_count}";
        conflicted = "";
        up_to_date = "✓";
        untracked = "?";
        modified = "";
        staged = "";
        renamed = "➜";
        deleted = "";
        stashed = "≡";
      };
      nix_shell = {
        symbol = "  ";
        format = "\\[[$symbol($state )(\\($name\\) )]($style)\\]";
      };
      nodejs = {
        symbol = "  ";
        format = "\\[[$symbol($version )]($style)\\]";
      };
      meson = {
        symbol = " 󰔷 ";
        format = "\\[[$symbol($project )]($style)\\]";
      };
      golang = {
        symbol = "  ";
        format = "\\[[$symbol($version )]($style)\\]";
      };
      rust = {
        symbol = " 󱘗 ";
        format = "\\[[$symbol($version )]($style)\\]";
      };
      terraform = {
        symbol = "  ";
        format = "\\[[$symbol($workspace )]($style)\\]";
      };
      zig = {
        symbol = "  ";
        format = "\\[[$symbol($version )]($style)\\]";
      };
      python = {
        symbol = "  ";
        format = "\\[[$symbol($pyenv_prefix( $version)(\\( $virtualenv\\)) )]($style)\\]";
      };
      kubernetes = {
        symbol = "  ";
        format = "\\[[$symbol($context( \\($namespace\\)) )]($style)\\]";
      };
      lua = {
        symbol = "  ";
        format = "\\[[$symbol($version )]($style)\\]";
      };
      helm = {
        symbol = "  ";
        format = "\\[[$symbol( $version)]($style)\\]";
      };
      package = {
        symbol = " 󰏗 ";
        format = "\\[[$symbol$version ]($style)\\]";
      };
      memory_usage = {
        symbol = "  ";
        format = "\\[[$symbol($ram | $swap )]($style)\\]";
        disabled = false;
      };
      # ==================================================
      # ====================Not Useful====================
      # ==================================================
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
      guix_shell = {
        symbol = " ";
        format = "\\[[$symbol]($style)\\]";
      };
      haskell = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      haxe = {
        symbol = " ";
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
      nim = {
        symbol = "󰆥 ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      ocaml = {
        symbol = " ";
        format = "\\[[$symbol($version)(\\($switch_indicator$switch_name\\))]($style)\\]";
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
      ruby = {
        symbol = " ";
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
      gradle = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
    };
  };
}

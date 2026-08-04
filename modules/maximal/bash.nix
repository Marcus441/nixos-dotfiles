{...}: {
  flake.modules.homeManager.maximal = [
    {
      programs.bash = {
        shellAliases = {
          nd = "nix develop -c $SHELL";
          ndi = "nix develop --impure -c $SHELL";
          gs = "git status";
          gc = "git checkout";
          gg = "git-graph --style round";
          nt = "nix flake init --refresh --template github:Marcus441/nix-templates/main#";
          nf = "nix flake init --template templates#";
        };

        profileExtra = ''
          if uwsm check may-start > /dev/null && uwsm select; then
            uwsm start default | systemd-cat -t uwsm_start
          fi
        '';

        initExtra = ''
          # List TODO/FIXME/NOTE/HACK comments and open in nvim
          vtodo() {
            local result file line
            result=$(rg --color=always --line-number --no-heading \
                'TODO|FIXME|HACK|NOTE|BUG|WARN' \
              | fzf --ansi --height=60% --layout=reverse --border \
                    --delimiter=: \
                    --preview 'bat --style=numbers --color=always --highlight-line {2} {1} 2>/dev/null || cat {1}' \
                    --preview-window=right:55%:+{2}-5)
            if [[ -n $result ]]; then
              file=''${result%%:*}
              line=$(cut -d: -f2 <<<"$result")
              nvim +"$line" "$file"
            fi
          }
        '';
      };
    }
  ];
}

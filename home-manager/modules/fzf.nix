{
  programs.fzf = {
    enable = true;

    defaultCommand = "fd --type f";
    changeDirWidgetCommand = "fd --type d";

    defaultOptions = [
      "--height 40%"
      "--border"
      "--layout=reverse"
    ];

    fileWidgetOptions = [
      "--preview 'head -50 {}'"
    ];

    changeDirWidgetOptions = [
      "--preview 'tree -C {} | head -100'" #
    ];
  };
}

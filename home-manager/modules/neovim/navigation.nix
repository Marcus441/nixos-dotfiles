{
  programs.nvf.settings.vim = {
    navigation = {
      harpoon = {
        enable = true;
        mappings = {
          file1 = "<A-q>";
          file2 = "<A-w>";
          file3 = "<A-e>";
          file4 = "<A-r>";
          markFile = "<A-m>";
          listMarks = "<A-l>";
        };
        setupOpts = {
          defaults = {
            save_on_toggle = true;
            sync_on_ui_close = true;
          };

          # Optional: customize UI style for the menu
          menu = {
            title = "Harpoon";
            title_pos = "center";
            border = "rounded";
            ui_width_ratio = 0.40;
          };
        };
      };
    };
  };
}

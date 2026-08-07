{config, ...}: {
  flavor = {
    dark = "";
    light = "";
  };
  mgr = {
    marker_marked = {
      fg = "lightcyan";
      bg = "lightcyan";
    };
    tab_width = 1;
    border_symbol = "│";
    syntect_theme = "${config.desktop.syntaxTheme}";
  };
  indicator.padding = {
    open = "▐";
    close = "▌";
  };
  status = {
    sep_left = {
      open = "▐";
      close = "▌";
    };
    sep_right = {
      open = "▐";
      close = "▌";
    };
  };
  which = {
    cols = 3;
    separator = "  ";
  };
  confirm = {
    border = {fg = "gray";};
    title = {
      fg = "blue";
      bold = true;
    };
    content = {};
    list = {};
    btn_yes = {
      bg = "green";
      fg = "black";
      bold = true;
    };
    btn_no = {
      bg = "red";
      fg = "black";
      bold = true;
    };
    btn_labels = ["  [Y]es  " "  (N)o  "];
  };
  spot = {
    border = {fg = "blue";};
    title = {fg = "blue";};
    tbl_col = {fg = "blue";};
    tbl_cell = {
      fg = "yellow";
      reversed = true;
    };
  };
  notify = {
    title_info = {fg = "green";};
    title_warn = {fg = "yellow";};
    title_error = {fg = "red";};
    icon_info = "";
    icon_warn = "";
    icon_error = "";
  };
  cmp = {
    active = {reversed = true;};
    inactive = {};
    icon_file = "";
    icon_folder = "";
    icon_command = "";
  };
}

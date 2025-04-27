{pkgs, ...}:
{
  config.vim.extraPlugins = with pkgs.vimPlugins; {

    gruvbox-material = {
      package = gruvbox-material;
      setup = ''
    config = function()
    -- Optionally configure and load the colorscheme
    -- directly inside the plugin declaration.
    vim.g.gruvbox_material_background = 'hard'
    vim.g.gruvbox_material_foreground = 'material'
    vim.g.gruvbox_material_better_performance = 1
    vim.g.gruvbox_material_enable_italic = true
    vim.g.gruvbox_material_transparent_background = 2
    -- Optionally configure and load the colorscheme
    -- directly inside the plugin declaration.
    vim.cmd.colorscheme 'gruvbox-material'
  end,      '';
    };
  };
}

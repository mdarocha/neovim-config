{ pkgs, ... }:
with pkgs.vimPlugins;

[{
  plugin = nvim-tree-lua;
  config = ''
    lua <<END
      -- disable the default file explorer
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true
        },
        view = {
          number = false,
          relativenumber = false
        }
      })
    END
    map <C-n> :NvimTreeToggle<CR>
  '';
}]

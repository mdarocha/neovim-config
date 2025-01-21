{ pkgs, ... }:
with pkgs.vimPlugins;

[
  {
    plugin = lualine-nvim;
    config = ''
      set laststatus=3
      set noshowmode

      lua <<EOF
        require('lualine').setup {
          options = {
            theme = 'NeoSolarized',
            section_separators = "",
            component_separators = "",
            globalstatus = true,
            icons_enabled = true,
            disabled_filetypes = { "NvimTree", "TelescopePrompt" },
          },
          sections = {
            lualine_a = { 'mode' },
            lualine_b = {
              'branch',
              { 'diff', colored = true }
            },
            lualine_c = {
              'filename'
            },
            lualine_x = { 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' }
          },
          tabline = {
            lualine_a = {
              {
                'tabs',
                tab_max_length = 40,
                max_length = vim.o.columns - 25,
                mode = 2,
                path = 0,
                show_modified_status = true,
              }
            }
          }
        }
      EOF
    '';
  }
]

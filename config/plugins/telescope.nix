{ pkgs, ... }:
with pkgs.vimPlugins;

[
  project-nvim
  telescope-fzf-native-nvim
  {
    plugin = telescope-nvim;
    config = ''
      lua <<EOF
        require('project_nvim').setup()

        require('telescope').load_extension('fzf')
        require('telescope').load_extension('projects')

        local is_inside_work_tree = {}
        project_files = function()
          local opts = {}

          local cwd = vim.fn.getcwd()
          if is_inside_work_tree[cwd] == nil then
            vim.fn.system("git rev-parse --is-inside-work-tree")
            is_inside_work_tree[cwd] = vim.v.shell_error == 0
          end

          if is_inside_work_tree[cwd] then
            require("telescope.builtin").git_files(opts)
          else
            require("telescope.builtin").find_files(opts)
          end
        end
      EOF

      nnoremap <Leader>g <cmd>Telescope live_grep<cr>
      nnoremap <Leader>f <cmd>lua project_files()<cr>
      nnoremap <Leader>o <cmd>Telescope projects projects<cr>

      nnoremap <silent> <c-]>     <cmd>Telescope lsp_implementations layout_strategy=vertical<CR>
      nnoremap <silent> gr        <cmd>Telescope lsp_references layout_strategy=vertical<CR>
      nnoremap gd                 <cmd>lua require('omnisharp_extended').telescope_lsp_definitions()<cr>
    '';
  }
]

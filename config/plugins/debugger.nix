{ pkgs, ... }:
with pkgs.vimPlugins;

[
  {
    plugin = nvim-dap;
    config = ''
      nnoremap <silent> <leader>b <cmd>lua require'dap'.toggle_breakpoint()<CR>
      nnoremap <silent> <leader>so <cmd>lua require'dap'.step_over()<CR>
      nnoremap <silent> <leader>si <cmd>lua require'dap'.step_into()<CR>

      lua <<EOF
        local dap = require('dap')
        dap.adapters.coreclr = {
          type = 'executable',
          command = 'netcoredbg',
          args = {'--interpreter=vscode'}
        }

        dap.configurations.cs = {
          {
            type = "coreclr",
            name = "launch - netcoredbg",
            request = "launch",
            program = function()
                return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
            end,
          },
        }
      EOF
    '';
  }
]

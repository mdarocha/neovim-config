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

vim.keymap.set('n', '<Leader>g', '<cmd>Telescope live_grep<CR>', { remap = false, silent = true })
vim.keymap.set('n', '<Leader>f', function() project_files() end, { remap = false, silent = true })
vim.keymap.set('n', '<Leader>o', '<cmd>Telescope projects projects<CR>', { remap = false, silent = true })

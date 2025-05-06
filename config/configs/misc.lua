-- flatten.nvim
require('flatten').setup {
  window = {
    open = 'vsplit'
  }
}

-- colorscheme
require('NeoSolarized').setup {
  style = 'dark',
  transparent = false,
  terminal_colors = true,
  styles = {
    string = { italic = false },
    keywords = { italic = false },
  },
    on_highlights = function(highlights, colors)
      -- WhichKey icons
      highlights.WhichKeyIcon = { fg = colors.blue }
      highlights.WhichKeyIconAzure = { fg = colors.blue }
      highlights.WhichKeyIconBlue = { fg = colors.blue }
      highlights.WhichKeyIconCyan = { fg = colors.cyan }
      highlights.WhichKeyIconGreen = { fg = colors.green }
      highlights.WhichKeyIconGrey = { fg = colors.gray }
      highlights.WhichKeyIconOrange = { fg = colors.orange }
      highlights.WhichKeyIconPurple = { fg = colors.magenta }
      highlights.WhichKeyIconRed = { fg = colors.red }
      highlights.WhichKeyIconYellow = { fg = colors.yellow }

      -- fixup floating windows
      -- match title color to background
      highlights.FloatTitle = { fg = colors.base1, bg = colors.bg1 }
    end,
}

vim.opt.termguicolors = true
vim.cmd("colorscheme NeoSolarized")

-- Disable EditorConfig for gitcommit
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  command = "let b:EditorConfig_disable = 1"
})

-- treesitter
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true
  },
  incremental_selection = {
    enable = true
  },
  indentation = {
    enable = true
  },
}

-- also enable treesitter-based folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- which-key.nvim
require("which-key").setup {
  preset = "helix",
  delay = 300
}

local no_numbers_ft = { "NvimTree", "TelescopePrompt", "codecompanion" }

require('numbers').setup {
  excluded_filetypes = no_numbers_ft
}

-- disable number line for certain filetypes
vim.api.nvim_create_autocmd({"FileType", "BufEnter", "WinEnter"}, {
  pattern = no_numbers_ft,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end
})

-- disable number line for floating windows
vim.api.nvim_create_autocmd({"WinEnter", "BufEnter"}, {
  callback = function()
    local is_floating = vim.api.nvim_win_get_config(0).relative ~= ""
    if is_floating then
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
    end
  end
})

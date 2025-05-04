-- flatten.nvim
require('flatten').setup({
  window = {
    open = 'vsplit'
  }
})

-- colorscheme
require('NeoSolarized').setup {
  style = 'dark',
  transparent = false,
  terminal_colors = true,
  styles = {
    string = { italic = false },
    keywords = { italic = false },
  }
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

-- avante
require("avante_lib").load()
require("avante").setup {
  provider = "copilot",
  behaviour = {
    auto_suggestions = false,
    enable_token_counting = false
  },
  windows = {
    width = 40,
    sidebar_header = {
      enable = false
    },
    input = {
      height = 4
    }
  }
}

-- disable number line for certain filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "NvimTree", "TelescopePrompt", "Avante", "AvanteInput", "AvanteSelectedFiles" },
  callback = function()
    vim.opt_local.number = false
  end
})

require('numbers').setup {
  exclude_filetypes = { "NvimTree", "TelescopePrompt", "Avante", "AvanteInput", "AvanteSelectedFiles" },
}

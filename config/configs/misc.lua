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
require'nvim-treesitter.configs'.setup {
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

-- codecompanion.nvim
require("codecompanion").setup {
  adapters = {
    copilot = function ()
      return require("codecompanion.adapters").extend("copilot", {
        schema = {
          model = {
            default = "claude-3.7-sonnet",
          }
        }
      })
    end
  },
  strategies = {
    chat = {
      slash_commands = {
        ["file"] = {
          -- Location to the slash command in CodeCompanion
          callback = "strategies.chat.slash_commands.file",
          description = "Select a file using Telescope",
          opts = {
            provider = "telescope", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
            contains_code = true,
          },
        },
        ["help"] = {
          -- Location to the slash command in CodeCompanion
          callback = "strategies.chat.slash_commands.help",
          description = "Search help tags using Telescope",
          opts = {
            provider = "telescope", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
            contains_code = true,
          },
        },
        ["buffer"] = {
          -- Location to the slash command in CodeCompanion
          callback = "strategies.chat.slash_commands.buffer",
          description = "Select a buffer using Telescope",
          opts = {
            provider = "telescope", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
            contains_code = true,
          },
        },
      },
    },
  },
  display = {
    action_palette = {
      provider = "telescope",
    },
    chat = {
      show_settings = false,
    }
  }
}

vim.keymap.set({ "n", "v" }, "<leader>C", "<cmd>CodeCompanionActions<cr>", {
  remap = false, silent = true, desc = "Code Companion: Actions"
})

vim.keymap.set({ "n", "v" }, "<leader>c", "<cmd>CodeCompanionChat Toggle<cr>", {
  remap = false, silent = true, desc = "Code Companion: Chat"
})

-- render-markdown.nvim, for codecompanion chat views
require('render-markdown').setup {
  file_types = { "codecompanion" },
  anti_conceal = { enabled = false }
}

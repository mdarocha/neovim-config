-- diagnostic config
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰳦',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    }
  }
})

-- keymaps
-- remove default neovim lsp keymaps
vim.keymap.del("n", "grr")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grn")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "<C-w>d")

-- functions to set lsp keymaps as buffer-local mappings
local function set_lsp_keymaps(buf)
  local opts = { remap = false, silent = true, buffer = buf }

  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover { border = "rounded" }
  end, opts)

  vim.keymap.set("n", "<A-k>", function()
    vim.diagnostic.open_float { border = "rounded" }
  end, opts)

  vim.keymap.set({ "n", "i" }, "<C-k>", function()
    vim.lsp.buf.signature_help { border = "rounded" }
  end, opts)

  vim.keymap.set("n", "<A-Enter>", vim.lsp.buf.code_action, opts)

  vim.keymap.set("n", "<C-]>", function()
    require("telescope.builtin").lsp_implementations { layout_strategy = "vertical" }
  end, opts)

  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {
    remap = false,
    silent = true,
    buffer = buf,
    desc = "LSP: Rename",
  })

  vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, {
    remap = false,
    silent = true,
    buffer = buf,
    desc = "LSP: Document Symbol",
  })

  vim.keymap.set("n", "gr", function()
    require("telescope.builtin").lsp_references { layout_strategy = "vertical" }
  end, {
    remap = false,
    silent = true,
    buffer = buf,
    desc = "LSP: References",
  })

  vim.keymap.set("n", "gd", function()
    require("telescope.builtin").lsp_definitions { layout_strategy = "vertical" }
  end, {
    remap = false,
    silent = true,
    buffer = buf,
    desc = "LSP: Definitions",
  })
end

-- set keymaps when opening a file that's not a help file
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*" },
  callback = function(event)
    local filetype = vim.bo.filetype
    if filetype ~= "help" and filetype ~= "man" then
      set_lsp_keymaps(event.buf)
    end
  end,
})

-- copilot
require("copilot").setup({
  lsp_binary = "copilot-language-server",
  suggestion = { enabled = false },
  panel = { enabled = false, },
  filetypes = {
    markdown = true,
    lua = true,
    yaml = true,
    gitcommit = true
  },
})

-- lazy.nvim
require("lazy-lsp").setup {
  prefer_local = false,
  default_config = {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
    -- disable lsp highlighting, since we use treesitter
    on_init = function(client)
      if client.server_capabilities then
        client.server_capabilities.semanticTokensProvider = nil
      end
    end
  },
  -- https://github.com/dundalek/lazy-lsp.nvim/blob/master/servers.md#curated-servers
  excluded_servers = {
    "ccls",                            -- prefer clangd
    "denols",                          -- prefer eslint and ts_ls
    "docker_compose_language_service", -- yamlls should be enough?
    "flow",                            -- prefer eslint and ts_ls
    "ltex",                            -- grammar tool using too much CPU
    "quick_lint_js",                   -- prefer eslint and ts_ls
    "scry",                            -- archived on Jun 1, 2023
    "biome",                           -- not mature enough to be default
    "oxlint",                          -- prefer eslint
    "tailwindcss"
  },
  preferred_servers = {
    markdown = {},
    python = { "pylsp", "ruff" },
    nix = { "nil_ls" }
  },
  -- overrides for some servers
  configs = {
    omnisharp = {
      cmd = {
        "OmniSharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()),
        "FormattingOptions:EnableEditorConfigSupport=true",
        "RoslynExtensionsOptions:enableDecompilationSupport=true"
      },
      handlers = {
        ["textDocument/definition"] = require('omnisharp_extended').definition_handler,
        ["textDocument/typeDefinition"] = require('omnisharp_extended').type_definition_handler,
        ["textDocument/references"] = require('omnisharp_extended').references_handler,
        ["textDocument/implementation"] = require('omnisharp_extended').implementation_handler,
      }
    },
    yamlls = {
      settings = {
        yaml = {
          schemas = require('schemastore').json.schemas(),
        },
      }
    },
    jsonls = {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
        },
      }
    },
    nil_ls = {
      settings = {
        ['nil'] = {
          nix = {
            flake = {
              autoArchive = false
            }
          }
        }
      }
    },
    lua_ls = {
      on_init = function(client)
        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using (most
            -- likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            -- Tell the language server how to find Lua modules same way as Neovim
            -- (see `:h lua-module-load`)
            path = {
              'lua/?.lua',
              'lua/?/init.lua',
            },
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
            }
          }
        })
      end,
      settings = {
        Lua = {
         runtime = {
            version = 'LuaJIT',
            path = vim.split(package.path, ';'),
          },
          diagnostics = {
            globals = { 'vim' },
          },
        }
      }
    }
  }
}

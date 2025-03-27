-- keymaps

-- functions to set lsp keymaps as buffer-local mappings
local function set_lsp_keymaps(buf)
  local opts = { remap = false, silent = true, buffer = buf }

  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<A-Enter>", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, opts)

  vim.keymap.set("n", "<C-]>", function()
    require("telescope.builtin").lsp_implementations { layout_strategy = "vertical" }
  end, opts)

  vim.keymap.set("n", "gr", function()
    require("telescope.builtin").lsp_references { layout_strategy = "vertical" }
  end, opts)

  vim.keymap.set("n", "gd", function()
    require("omnisharp_extended").telescope_lsp_definitions()
  end, opts)
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
  suggestion = { enabled = false },
  panel = { enabled = false, },
  filetypes = {
    pass = false,
    markdown = true,
    lua = true
  },
})

-- mason
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require("mason-lspconfig").setup()

-- auto-setup installed lsp servers
require("mason-lspconfig").setup_handlers {
    -- default handler - just the default setup
    function (server_name)
        local capabilities = require('blink.cmp').get_lsp_capabilities()

        require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            on_attach = function(client)
              -- disable lsp highlighting, since we use treesitter
              client.server_capabilities.semanticTokensProvider = nil
            end
        }
    end,
    -- overrides for some servers
    ["omnisharp"] = function ()
      require("lspconfig").omnisharp.setup {
        cmd = {
          "OmniSharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()),
          "FormattingOptions:EnableEditorConfigSupport=true",
          "RoslynExtensionsOptions:enableDecompilationSupport=true"
        },
        handlers = {
          ["textDocument/definition"] = require('omnisharp_extended').handler,
        }
      }
    end,
    ["yamlls"] = function ()
      require("lspconfig").yamlls.setup {
        settings = {
          yaml = {
            schemas = require('schemastore').json.schemas(),
          },
        }
      }
    end,
    ["jsonls"] = function ()
      require("lspconfig").jsonls.setup {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
          },
        }
      }
    end,
    ["lua_ls"] = function  ()
      require("lspconfig").lua_ls.setup {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc')) then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT'
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
        settings = { Lua = {} }
    }
    end,
    ["tailwindcss"] = function ()
      require("lspconfig").tailwindcss.setup {
        root_dir = require("lspconfig.util").root_pattern(".git"),
      }
    end
}

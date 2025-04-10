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
  lsp_binary = "copilot-language-server",
  suggestion = { enabled = false },
  panel = { enabled = false, },
  filetypes = {
    pass = false,
    markdown = true,
    lua = true
  },
})

-- lazy.nvim
require("lazy-lsp").setup {
  prefer_local = false,
  default_config = {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
    on_attach = function(client)
      -- disable lsp highlighting, since we use treesitter
    end,
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
  },
  preferred_servers = {
    markdown = {},
    python = { "pylsp", "ruff" },
    nix = { "nil_ls" },
  },
  -- overrides for some servers
  config = {
    omnisharp = {
      cmd = {
        "OmniSharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()),
        "FormattingOptions:EnableEditorConfigSupport=true",
        "RoslynExtensionsOptions:enableDecompilationSupport=true"
      },
      handlers = {
        ["textDocument/definition"] = require('omnisharp_extended').handler,
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
    lua_ls = {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" }
          }
        }
      }
    },
    tailwindcss = {
      root_dir = require("lspconfig.util").root_pattern(".git"),
      autostart = false
    }
  }
}

nnoremap <silent> K         <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <c-k>     <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>r <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <A-Enter> <cmd>lua vim.lsp.buf.code_action()<CR>

lua <<EOF
local lspconfig = require'lspconfig'
local configs = require'lspconfig/configs'
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- extend the default config to hook in cmp capabilities and lsp-status
lspconfig.util.default_config = vim.tbl_extend(
    "force",
    lspconfig.util.default_config,
    {
        capabilities = capabilities,
        on_attach = function(client)
            -- disable lsp highlighting, since we use treesitter
            client.server_capabilities.semanticTokensProvider = nil
        end
    }
)

lspconfig.ccls.setup{}
lspconfig.ts_ls.setup{
    root_dir=lspconfig.util.root_pattern("package.json", "tsconfig.json")
}
lspconfig.denols.setup{
    root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
    init_options = {
      lint = true,
      unstable = true,
      suggest = {
        imports = {
          hosts = {
            ["https://deno.land"] = true,
          },
        },
      },
    },
    on_attach = function()
      local active_clients = vim.lsp.get_active_clients()
      for _, client in pairs(active_clients) do
        -- stop tsserver if denols is already active
        if client.name == "tsserver" then
          client.stop()
        end
      end
    end,
}
lspconfig.pylsp.setup{
    root_dir=lspconfig.util.root_pattern("deno.json", "deno.jsonc")
}
lspconfig.texlab.setup{}
lspconfig.rust_analyzer.setup{}
lspconfig.omnisharp.setup{
    cmd={
        "OmniSharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()),
        "FormattingOptions:EnableEditorConfigSupport=true",
        "RoslynExtensionsOptions:enableDecompilationSupport=true"
    },
    handlers = {
        ["textDocument/definition"] = require('omnisharp_extended').handler,
    }
}
lspconfig.gopls.setup{}
lspconfig.zls.setup{}
lspconfig.yamlls.setup{
    settings = {
        yaml = {
            schemas = require('schemastore').json.schemas(),
        },
    }
}
lspconfig.jsonls.setup{
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
        },
    }
}
lspconfig.cssls.setup{}
lspconfig.html.setup{}
lspconfig.nixd.setup{}
lspconfig.terraformls.setup{}
EOF

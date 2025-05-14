require("blink.cmp").setup {
  keymap = { preset = "default" },
  signature = {
    enabled = true,
    window = {
      show_documentation = false,
      border = 'rounded',
    }
  },
  completion = {
    menu = { border = 'none' },
    documentation = { window = { border = 'rounded' } },
  },
  sources = {
    default = { 'lsp', 'path', 'copilot', 'git', 'snippets', 'buffer' },
    per_filetype = {
      codecompanion = { 'codecompanion' },
    },
    providers = {
      copilot = {
        name = "copilot",
        module = "blink-copilot",
        score_offset = 100,
        async = true
      },
      git = {
        name = "git",
        module = "blink-cmp-git"
      }
    }
  }
}

require("blink.cmp").setup {
  keymap = { preset = "default" },
  signature = {
    enabled = true,
    window = {
      show_documentation = false
    }
  },
  sources = {
    default = { 'lsp', 'path', 'copilot', 'git', 'snippets', 'buffer' },
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

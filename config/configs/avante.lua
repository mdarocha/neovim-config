require("avante_lib").load()
require("avante").setup {
  provider = "copilot",
  behaviour = {
    auto_suggestions = false,
    auto_focus_sidebar = false,
    enable_token_counting = false,
    support_paste_from_clipboard = true,
    enable_cursor_planning_mode = true
  },
  windows = {
    width = 40,
    sidebar_header = {
      enable = false
    },
    edit = {
      start_insert = false
    },
    ask = {
      start_insert = false
    }
  },
  hints = { enabled = false },
  file_selector = { provider = "telescope" },
  mappings = {
    sidebar = {
      close = { "q" },
      close_from_input = {
        normal = "q",
        insert = "<C-d>",
      },
    }
  }
}



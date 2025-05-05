require("codecompanion").setup {
  adapters = {
    copilot = function ()
      return require("codecompanion.adapters").extend("copilot", {
        schema = {
          model = {
            default = "gemini-2.5-pro",
          }
        }
      })
    end
  },
  strategies = {
    chat = {
      roles = {
        llm = function(adapter)
          local model_name = ""
          if adapter.schema and adapter.schema.model and adapter.schema.model.default then
            local model = adapter.schema.model.default
            if type(model) == "function" then
              model = model(adapter)
            end
            model_name = "(" .. model .. ")"
          end
          return "  " .. adapter.formatted_name .. model_name
        end,
        user = " User",
      },
      keymaps = {
        send = {
          modes = {
            n = "<CR>",
            i = "<C-S>",
          },
          callback = function(chat)
            vim.cmd("stopinsert")
            chat:submit()
          end,
          index = 1,
          description = "Send",
        },
        close = {
          modes = {
            n = "q",
          },
          index = 3,
          callback = "keymaps.close",
          description = "Close Chat",
        },
        stop = {
          modes = {
            n = "<C-c>",
          },
          index = 4,
          callback = "keymaps.stop",
          description = "Stop Request",
        },
      },
      slash_commands = {
        ["help"] = {
          opts = {
            prompt_trim = false, -- Disable the prompt for trimming long help files
          },
        },
      },
    },
    inline = { adapter = "copilot" },
    agent = { adapter = "copilot" },
  },
  inline = {
    layout = "buffer", -- vertical|horizontal|buffer
  },
  display = {
    action_palette = {
      provider = "telescope",
    },
    chat = {
      icons = {
        pinned_buffer = "📌",
        watched_buffer = "👀",
      },
      intro_message = "Hello!",
      show_header_separator = true,
      separator = "─",
      show_settings = false,
      show_token_count = false,
      window = {
        width = 0.4
      },
    },
    diff = {
      provider = "default"
    }
  }
}

vim.keymap.set({ "n", "v" }, "<leader>C", "<cmd>CodeCompanionActions<cr>", {
  remap = false, silent = true, desc = "Code Companion: Actions"
})

vim.keymap.set({ "n", "v" }, "<leader>c", "<cmd>CodeCompanionChat Toggle<cr>", {
  remap = false, silent = true, desc = "Code Companion: Chat"
})

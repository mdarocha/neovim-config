-- Single spinner info table for all state
local spinner_info = {
  processing = false,
  spinner_index = 1,
  namespace_id = nil,
  timer = nil,
  spinner_symbols = {
    "⠋",
    "⠙",
    "⠹",
    "⠸",
    "⠼",
    "⠴",
    "⠦",
    "⠧",
    "⠇",
    "⠏",
  },
  filetype = "codecompanion"
}

-- Helper function to get buffer by filetype
local function get_buf(ft)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == ft then
      return buf
    end
  end
  return nil
end

-- Forward declaration for mutually recursive functions if needed,
-- but simple reordering works here.
local update_spinner -- Not strictly necessary after reordering, but good practice if complex

-- Stop the spinner animation
local function stop_spinner()
  spinner_info.processing = false

  if spinner_info.timer then
    spinner_info.timer:stop()
    spinner_info.timer:close()
    spinner_info.timer = nil
  end

  local buf = get_buf(spinner_info.filetype)
  if buf == nil then
    return
  end

  -- Ensure namespace_id is valid before clearing
  if spinner_info.namespace_id then
      vim.api.nvim_buf_clear_namespace(buf, spinner_info.namespace_id, 0, -1)
  end
end

-- Update the spinner animation
update_spinner = function() -- Assign to the forward-declared variable
  if not spinner_info.processing then
    stop_spinner() -- Now calls the already defined stop_spinner
    return
  end

  spinner_info.spinner_index = (spinner_info.spinner_index % #spinner_info.spinner_symbols) + 1

  local buf = get_buf(spinner_info.filetype)
  if buf == nil then
    -- If buffer is gone, stop the spinner
    stop_spinner()
    return
  end

  -- Ensure namespace_id is valid before using
  if not spinner_info.namespace_id then
      -- Optionally create it here if it might be missing, or just return/error
      -- For now, let's assume init() always runs first and sets it.
      -- If not, add: spinner_info.namespace_id = vim.api.nvim_create_namespace("CodeCompanionSpinner")
      -- Or simply stop if it's missing:
      stop_spinner()
      return
  end

  -- Clear previous virtual text
  vim.api.nvim_buf_clear_namespace(buf, spinner_info.namespace_id, 0, -1)

  local last_line = vim.api.nvim_buf_line_count(buf) - 1
  -- Ensure last_line is not negative (empty buffer)
  if last_line < 0 then last_line = 0 end

  vim.api.nvim_buf_set_extmark(buf, spinner_info.namespace_id, last_line, 0, {
    virt_lines = { { { spinner_info.spinner_symbols[spinner_info.spinner_index] .. " Processing...", "Comment" } } },
    virt_lines_above = false, -- false means below the line
  })
end

-- Start the spinner animation
local function start_spinner()
  -- Ensure namespace is created before starting
  if not spinner_info.namespace_id then
      spinner_info.namespace_id = vim.api.nvim_create_namespace("CodeCompanionSpinner")
  end

  spinner_info.processing = true
  spinner_info.spinner_index = 0 -- Start from the beginning

  if spinner_info.timer then
    spinner_info.timer:stop()
    spinner_info.timer:close()
    spinner_info.timer = nil
  end

  spinner_info.timer = vim.loop.new_timer()
  spinner_info.timer:start(
    0, -- Start immediately
    100, -- Repeat every 100ms
    vim.schedule_wrap(function()
      -- Add safety check in case timer fires after stop_spinner was called but before timer was closed
      if not spinner_info.processing then
          if spinner_info.timer then
              spinner_info.timer:stop()
              spinner_info.timer:close()
              spinner_info.timer = nil
          end
          return
      end
      update_spinner()
    end)
  )
end

-- Initialize the spinner
local function init()
  -- Create namespace for virtual text if not already created
  if not spinner_info.namespace_id then
    spinner_info.namespace_id = vim.api.nvim_create_namespace("CodeCompanionSpinner")
  end

  -- Check if augroup already exists before creating
  local group_exists = vim.fn.exists("#CodeCompanionHooks") > 0
  local group
  if group_exists then
      group = vim.api.nvim_get_autocmds({ group = "CodeCompanionHooks" }) -- Check if empty? Better to just clear and recreate
      vim.api.nvim_del_augroup_by_name("CodeCompanionHooks") -- Clear existing group to avoid duplicate autocmds
  end
  group = vim.api.nvim_create_augroup("CodeCompanionHooks", { clear = true }) -- Use clear=true directly

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequest*",
    group = group,
    callback = function(request)
      if request.match == "CodeCompanionRequestStarted" then
        start_spinner()
      elseif request.match == "CodeCompanionRequestFinished" then
        stop_spinner()
      end
    end,
  })
end

-- Initialize immediately
init()


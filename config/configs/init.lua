-- Autoreload files, support hmr better
vim.opt.autoread = true
vim.opt.backupcopy = "yes"

-- See whitespace characters
vim.opt.encoding = "utf-8"
vim.opt.list = true
vim.opt.listchars = "tab:→ ,trail:·,precedes:⇐,extends:⇒,nbsp:¬"

-- No wrapping
vim.opt.wrap = false

-- Tabs as 4 spaces
vim.opt.tabstop = 8
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = true

-- Use tab characters for makefiles and go
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "make" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.listchars:append("tab:  ")
  end
})

-- Format Nix, Lua with 2 spaces
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "nix", "lua" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end
})

-- Spellcheck when writing natural text
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"tex", "mail", "gitcommit", "markdown"},
  callback = function()
    local is_floating = vim.api.nvim_win_get_config(0).relative ~= ""
    if is_floating == false then
      vim.opt_local.spell = true
      vim.opt_local.spelllang= "pl,en_us"
    end
  end
})

-- Misc visual stuff
vim.opt.showcmd = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.showmatch = true
vim.opt.title = true
vim.opt.hlsearch = true
vim.opt.mouse = "a"
vim.opt.mousemodel = "extend"
vim.opt.colorcolumn = "80,120"
vim.opt.signcolumn = "yes:1"

-- Moving around splits
vim.keymap.set("n", "gh", "<C-w>h", {
  remap = false, silent = true, desc = "Move to left split"
})
vim.keymap.set("n", "gj", "<C-w>j", {
  remap = false, silent = true, desc = "Move to bottom split"
})
vim.keymap.set("n", "gk", "<C-w>k", {
  remap = false, silent = true, desc = "Move to top split"
})
vim.keymap.set("n", "gl", "<C-w>l", {
  remap = false, silent = true, desc = "Move to right split"
})

-- Leader map
vim.g.mapleader = "\\"

-- Folding
vim.opt.foldenable = true
vim.opt.foldlevelstart = 99

-- Terminal setups
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { remap = false, silent = true })
vim.opt.shell = "zsh"

-- Open a new terminal in a split
vim.keymap.set("n", "<leader>t", function()
  vim.cmd("vsplit | terminal")
end, { remap = false, silent = true, desc = "Open terminal" })

-- Persist undo
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("cache") .. "/vimundo"

-- Clipboard integration
vim.opt.clipboard = "unnamedplus"

-- C# and F# filetype fixes
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.fsproj", "*.props", "*.csproj", "*.targets"},
  callback = function()
    vim.opt_local.filetype = "xml"
  end
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.fs",
  callback = function()
    vim.opt_local.filetype = "fsharp"
  end
})

-- fix html template files to properly work with lsp
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = { "htmldjango", "htmlangular" },
  callback = function()
    vim.opt_local.filetype = "html"
  end
})

-- neovide setup
if vim.g.neovide then
  vim.opt.guifont = "Hack_Nerd_Font,Noto_Color_Emoji:h12"
end

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
  pattern = "make",
  command = "setlocal noexpandtab"
})

-- Go fixes
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  command = "setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4"
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  command = "setlocal listchars+=tab:\\ \\"
})

-- Nix formatting
vim.api.nvim_create_autocmd("FileType", {
  pattern = "nix",
  command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2"
})

-- Lua formatting
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2"
})

-- Spellcheck when writing natural text
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"tex", "mail", "gitcommit", "markdown"},
  command = "setlocal spell spelllang=pl,en_us"
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
vim.opt.signcolumn = "yes"

-- Moving around splits
vim.keymap.set("n", "gh", "<C-w>h", { remap = false, silent = true })
vim.keymap.set("n", "gj", "<C-w>j", { remap = false, silent = true })
vim.keymap.set("n", "gk", "<C-w>k", { remap = false, silent = true })
vim.keymap.set("n", "gl", "<C-w>l", { remap = false, silent = true })

-- Leader map
vim.g.mapleader = "\\"

-- Folding
vim.opt.foldenable = true
vim.opt.foldlevelstart = 99

-- Terminal setups
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { remap = false, silent = true })
vim.opt.shell = "zsh"

-- Persist undo
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("cache") .. "/vimundo"

-- Clipboard integration
vim.opt.clipboard = "unnamedplus"

-- C# and F# filetype fixes
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.fsproj", "*.props", "*.csproj", "*.targets"},
  command = "set filetype=xml"
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.fs",
  command = "set filetype=fsharp"
})

-- Neovide setup
if vim.g.neovide then
  vim.opt.guifont = "Hack_Nerd_Font,Noto_Color_Emoji:h12"
end

" Autoreload files, support hmr better
set autoread
set backupcopy=yes

" See whitespace characters
set encoding=utf-8
set list
set listchars=tab:→\ ,trail:·,precedes:⇐,extends:⇒,nbsp:¬

" No wrapping
set nowrap

" Tabs as 4 spaces
set tabstop=8
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab

" Use tab characters for makefiles and go
autocmd FileType make setlocal noexpandtab

"" Go fixes
" Make go format bearable
autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4
" Don't show tabs in go files
autocmd FileType go setlocal listchars+=tab:\ \

" Nix formatting
autocmd FileType nix setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

" Spellcheck when writing natural text
autocmd FileType tex setlocal spell spelllang=pl,en_us
autocmd FileType mail setlocal spell spelllang=pl,en_us
autocmd FileType gitcommit setlocal spell spelllang=pl,en_us
autocmd FileType markdown setlocal spell spelllang=pl,en_us

" Misc visual stuff
set showcmd
set number
set relativenumber
set cursorline
set showmatch
set title
set hlsearch
set mouse=a
set mousemodel=extend
set colorcolumn=80,120
set signcolumn=yes

" Moving around splits
nmap gh <C-w>h
nmap gj <C-w>j
nmap gk <C-w>k
nmap gl <C-w>l

" Leader map
let mapleader = "\\"

" Folding
set foldenable
set foldlevelstart=99

" Terminal setups
tnoremap <Esc> <C-\><C-n>
set shell=~/.nix-profile/bin/zsh

" persist undo
set undofile
set undodir=~/.cache/vimundo

" clipboard integration
set clipboard+=unnamedplus

" C# and F# filetype fixes
au BufRead,BufNewFile *.fs set filetype=fsharp
au BufRead,BufNewFile *.fsproj set filetype=xml
au BufRead,BufNewFile *.props set filetype=xml
au BufRead,BufNewFile *.csproj set filetype=xml
au BufRead,BufNewFile *.targets set filetype=xml

" Neovide setup
lua << EOF
if vim.g.neovide then
    vim.o.guifont = "Hack_Nerd_Font,Noto_Color_Emoji:h12"
end
EOF

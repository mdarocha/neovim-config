{ pkgs, ... }:
with pkgs.vimPlugins;

[
  # nvim-cmp snippet setup
  luasnip
  cmp_luasnip
  # nvim-cmp sources
  cmp-nvim-lsp
  cmp-buffer
  cmp-path
  cmp-cmdline
  {
    plugin = nvim-cmp;
    config = ''
      set completeopt=menu,menuone,noselect
      lua <<EOF
        ${builtins.readFile ../configs/cmp.lua}
      EOF
    '';
  }
]

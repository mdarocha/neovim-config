{ pkgs, ... }:
with pkgs.vimPlugins;

[
  SchemaStore-nvim
  {
    plugin = nvim-lspconfig;
    config = (builtins.readFile ../configs/lsp.vim);
  }
]

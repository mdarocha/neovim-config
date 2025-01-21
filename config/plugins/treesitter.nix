{ pkgs, ... }:
with pkgs.vimPlugins;

[
  {
    plugin = nvim-treesitter.withAllGrammars;
    config = ''
      lua <<EOF
        require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true
          },
          incremental_selection = {
            enable = true
          },
          indentation = {
            enable = true
          },
        }
      EOF

      " Also enable treesitter-based folding
      set foldmethod=expr
      set foldexpr=nvim_treesitter#foldexpr()
    '';
  }
]

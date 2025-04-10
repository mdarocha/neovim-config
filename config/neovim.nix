{
  pkgs,
  lib,
  vimPluginSrcs,
  config,
  ...
}:

let
  cfg = config.mdarocha.neovim;

  inherit (pkgs.vimUtils) buildVimPlugin;

  numbers-vim = buildVimPlugin {
    name = "numbers.vim";
    src = vimPluginSrcs.numbers-vim;
  };
  vim-renamer = buildVimPlugin {
    name = "renamer.vim";
    src = vimPluginSrcs.vim-renamer;
  };

  NeoSolarized-nvim = buildVimPlugin {
    name = "NeoSolarized-nvim";
    src = vimPluginSrcs.neosolarized-nvim;
  };
in
{
  programs.neovim = lib.mkIf cfg.enable {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true; # required by copilot

    extraLuaConfig = let 
      files = builtins.attrNames (builtins.readDir ./configs);
      fileContents = builtins.map (file: builtins.readFile "${./configs}/${file}") files;
    in builtins.concatStringsSep "\n" fileContents;

    plugins = with pkgs.vimPlugins; [
      nvim-web-devicons
      vim-sensible
      numbers-vim
      vim-renamer
      vim-fugitive
      direnv-vim
      flatten-nvim
      NeoSolarized-nvim
      editorconfig-vim
      copilot-lua
      nvim-tree-lua
      lualine-nvim
      which-key-nvim
      project-nvim
      telescope-fzf-native-nvim
      telescope-nvim
      nvim-treesitter.withAllGrammars
      omnisharp-extended-lsp-nvim
      SchemaStore-nvim
      nvim-lspconfig
      lazy-lsp-nvim
      blink-cmp
      blink-copilot
      blink-cmp-git
    ];

    extraPackages = [
      # Required by telescope
      pkgs.ripgrep
      # Used by mason to install some lsps
      pkgs.gcc
      pkgs.cargo
      # Used by copilot
      pkgs.copilot-language-server
    ];
  };
}

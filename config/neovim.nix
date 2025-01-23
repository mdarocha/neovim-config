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
  vim-password-store = buildVimPlugin {
    name = "vim-password-store";
    src = vimPluginSrcs.vim-password-store;
  };
  vim-gtfo = buildVimPlugin {
    name = "vim-gtfo";
    src = vimPluginSrcs.vim-gtfo;
  };

  NeoSolarized-nvim = buildVimPlugin {
    name = "NeoSolarized-nvim";
    src = vimPluginSrcs.neosolarized-nvim;
  };

  pluginImports = [
    ./plugins/completion.nix
    ./plugins/debugger.nix
    ./plugins/filetree.nix
    ./plugins/lspconfig.nix
    ./plugins/statusbar.nix
    ./plugins/telescope.nix
    ./plugins/treesitter.nix
  ];

  # Packages required for LSP functionality
  lspPackages = with pkgs; [
    # c/c++
    ccls
    # rust
    rust-analyzer
    rustc
    # go
    go
    gopls
    # latex
    texlab
    # typescript and javascript
    nodePackages.typescript
    nodePackages.typescript-language-server
    deno
    # python
    (python3.withPackages (ps: with ps; [ python-lsp-server ]))
    # csharp / fsharp
    omnisharp-roslyn
    # zls
    zls
    # json/html/css
    nodePackages.vscode-langservers-extracted
    # yaml
    nodePackages.yaml-language-server
    # nix
    nixd
    # terraform
    terraform-ls
  ];

  # Debugger packages, required for DAP functionality
  dapPackages = with pkgs; [
    # csharp
    netcoredbg
  ];
in
{
  programs.neovim = lib.mkIf cfg.enable {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true; # required by copilot

    extraConfig = (builtins.readFile ./configs/init.vim);

    plugins =
      with pkgs.vimPlugins;
      [
        nvim-web-devicons
        vim-sensible
        vim-eunuch
        numbers-vim
        vim-renamer
        vim-dadbod
        vim-fugitive
        vim-password-store
        vim-gtfo
        direnv-vim
        {
          plugin = flatten-nvim;
          config = ''
            lua <<EOF
              require('flatten').setup({
                window = {
                  open = 'vsplit'
                }
              })
            EOF
          '';
        }
        omnisharp-extended-lsp-nvim
        {
          plugin = NeoSolarized-nvim;
          config = ''
            lua <<EOF
              require('NeoSolarized').setup {
                style = 'dark',
                transparent = false,
                terminal_colors = true,
                styles = {
                  string = { italic = false },
                  keywords = { italic = false },
                }
              }
            EOF
            set termguicolors
            colorscheme NeoSolarized
          '';
        }
        {
          plugin = editorconfig-vim;
          config = ''
            au FileType gitcommit let b:EditorConfig_disable = 1
          '';
        }
        {
          plugin = copilot-lua;
          config = ''
            lua <<EOF
              vim.api.nvim_set_var("copilot_status", "")
              local copilot_api = require("copilot.api")
              copilot_api.register_status_notification_handler(function(data)
                if data.status == 'Normal' then
                  vim.api.nvim_set_var("copilot_status", 'Normal')
                elseif data.status == 'InProgress' then
                  vim.api.nvim_set_var("copilot_status", 'In progress')
                else
                  vim.api.nvim_set_var("copilot_status", 'Offline')
                end
              end)

              require("copilot").setup({
                suggestion = { enabled = false },
                panel = {
                  enabled = true,
                  auto_refresh = true,
                  layout = { position = "right" }
                },
                filetypes = {
                  pass = false,
                  markdown = true,
                },
              })
            EOF
          '';
        }
        {
          plugin = copilot-cmp;
          config = ''
            lua <<EOF
              require("copilot_cmp").setup()
            EOF
          '';
        }
        {
          plugin = fidget-nvim;
          config = ''
            lua <<EOF
              require("fidget").setup()
            EOF
          '';
        }
      ]
      ++ lib.optionals (!cfg.disableLsp) (lib.lists.flatten (map (p: import p { inherit pkgs inputs; }) pluginImports));
    extraPackages =
      with pkgs;
      [
        # Required by telescope
        ripgrep
      ]
      ++ lspPackages
      ++ dapPackages;
  };
}

{ pkgs, lib, inputs, device-type, config, ... }:

let
  inherit (pkgs.vimUtils) buildVimPlugin;

  numbers-vim = buildVimPlugin {
    name = "numbers.vim";
    src = inputs.numbers-vim;
  };
  vim-renamer = buildVimPlugin {
    name = "renamer.vim";
    src = inputs.vim-renamer;
  };
  vim-password-store = buildVimPlugin {
    name = "vim-password-store";
    src = inputs.vim-password-store;
  };
  vim-gtfo = buildVimPlugin {
    name = "vim-gtfo";
    src = inputs.vim-gtfo;
  };

  NeoSolarized-nvim = buildVimPlugin {
    name = "NeoSolarized-nvim";
    src = inputs.neosolarized-nvim;
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
  dapPackages = with pkgs;
    [
      # csharp
      netcoredbg
    ];
in
{
  programs.neovide = {
    enable = true;
    settings = {};
  };

  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true; # required by copilot

    extraConfig = (builtins.readFile ./configs/init.vim);

    plugins = with pkgs.vimPlugins;
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
      ] ++ lib.lists.flatten (map (p: import p { inherit pkgs inputs; }) pluginImports);
    extraPackages = with pkgs;
      [
        # Required by telescope
        ripgrep
      ] ++ (lib.lists.optionals (device-type != "server") (lspPackages ++ dapPackages));
  };

  # ensure clipboard work and the needed fonts are installed
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    wl-clipboard
    nerd-fonts.hack
  ];

  xdg.desktopEntries = {
    # ensure neovide executes correctly
    neovide = {
      name = "Neovide";
      icon = "neovide";
      exec = if config.targets.genericLinux.enable
        then "${config.home.homeDirectory}/.nix-profile/bin/nixGLIntel ${config.home.homeDirectory}/.nix-profile/bin/neovide %F"
        else "${config.home.homeDirectory}/.nix-profile/bin/neovide %F";
      categories = [ "Utility" "TextEditor" ];
      mimeType = [
        "text/english"
        "text/plain"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
      ];
    };

    # hide the neovim desktop file
    nvim = {
      name = "Neovim";
      noDisplay = true;
    };
  };
}

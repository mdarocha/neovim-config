{
  description = "my custom neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # vim plugins
    numbers-vim = {
      url = "github:myusuf3/numbers.vim/master";
      flake = false;
    };

    vim-renamer = {
      url = "github:qpkorr/vim-renamer/master";
      flake = false;
    };

    vim-password-store = {
      url = "github:fourjay/vim-password-store/master";
      flake = false;
    };

    vim-gtfo = {
      url = "github:justinmk/vim-gtfo";
      flake = false;
    };

    neosolarized-nvim = {
      url = "github:Tsuzat/NeoSolarized.nvim";
      flake = false;
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      self,
      ...
    }:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      packages.x86_64-linux =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          testConfig = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              self.homeManagerModules.default
              {
                home = {
                  username = "marek";
                  homeDirectory = "/home/marek";
                  stateVersion = "25.05";
                };

                mdarocha = {
                  neovim.enable = true;
                };
              }
            ];
          };

          neovimConfig =
            pkgs.writeText "neovim-config.lua"
              testConfig.config.xdg.configFile."nvim/init.lua".text;
          neovimPkg = testConfig.config.programs.neovim.finalPackage;

          neovim = pkgs.writeShellScriptBin "neovim" ''
            ${neovimPkg}/bin/nvim -u ${neovimConfig} "$@"
          '';
        in
        {
          inherit neovim;
        };

      homeManagerModules = {
        default = import ./config {
          inherit (inputs)
            numbers-vim
            vim-renamer
            vim-password-store
            vim-gtfo
            neosolarized-nvim
            ;
        };
      };
    };
}

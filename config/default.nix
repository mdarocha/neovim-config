vimPluginSrcs:
{ lib, ... }:

let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) submodule;
in
{
  imports = [
    ./neovim.nix
    ./neovide.nix
  ];

  options.mdarocha = {
    neovim = mkOption {
      description = "Configuration for the customized Neovim";
      type = submodule {
        options = {
          enable = mkEnableOption "custom neovim";
        };
      };
    };

    neovide = mkOption {
      description = "Configuration for Neovide";
      type = submodule {
        options = {
          enable = mkEnableOption "neovide";
          useNixGl = mkEnableOption "nixGL";
        };
      };
    };
  };

  config = {
    _module.args = { inherit vimPluginSrcs; };
  };
}

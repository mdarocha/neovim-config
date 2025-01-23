vimPluginSrcs:
{ lib, ... }:

let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) submodule bool;
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

          disableLsp = mkOption {
            description = "If true, skips installation of LSP servers, reducing closure size";
            type = bool;
            default = false;
          };
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

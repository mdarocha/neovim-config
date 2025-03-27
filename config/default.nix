vimPluginSrcs:
{ config, lib, ... }:

let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) submodule bool;

  cfg = config.mdarocha;
in
{
  imports = [
    ./neovim.nix
  ];

  options.mdarocha = {
    neovim = mkOption {
      description = "Configuration for the customized Neovim";
      type = submodule {
        options = {
          enable = mkEnableOption "custom neovim";

          hideDesktopFile = mkOption {
            description = "If true, hides the desktop file for Neovim";
            type = bool;
            default = true;
          };
        };
      };
    };
  };

  config = {
    _module.args = { inherit vimPluginSrcs; };

    xdg.desktopEntries = lib.mkIf cfg.neovim.hideDesktopFile {
      nvim = {
        name = "Neovim";
        noDisplay = true;
      };
    };
  };
}

inputs:
{ lib, ... }:

let
  inherit (lib) mkOption;
  inherit (lib.types) bool;
in
{
  imports = [
    ./neovim.nix
    ./neovide.nix
  ];

  options.mdarocha.neovim-config = {
    enableNeovim = mkOption {
      type = bool;
      default = true;
      description = "Whether to enable Neovim with the custom config";
    };
    enableNeovide = mkOption {
      type = bool;
      default = true;
      description = "Whether to enable Neovide";
    };
    useNixGl = mkOption {
      type = bool;
      default = true;
      description = "Whether to use nixGL to run Neovide";
    };
  };

  config = {
    _module.args = { inherit inputs; };
  };
}

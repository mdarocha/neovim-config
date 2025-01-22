{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.mdarocha;
in
# TODO this assert makes an infinite recursion error
# assert lib.assertMsg (cfg.enableNeovim && cfg.enableNeovide) "neovim needs to be enabled to use neovide";
{
  config = lib.mkIf cfg.neovide.enable {
    programs.neovide = {
      enable = true;
      settings = { };
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
        exec =
          if cfg.neovide.useNixGl then
            "${config.home.homeDirectory}/.nix-profile/bin/nixGLIntel ${config.home.homeDirectory}/.nix-profile/bin/neovide %F"
          else
            "${config.home.homeDirectory}/.nix-profile/bin/neovide %F";
        categories = [
          "Utility"
          "TextEditor"
        ];
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
  };
}

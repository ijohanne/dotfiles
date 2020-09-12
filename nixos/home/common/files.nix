{ config, ... }:
let
  sources = import ../nix;
  pkgs = import sources.nixpkgs { overlays = [ ]; };
  dots = "${config.home.homeDirectory}/.dotfiles";
in {
  home.file = {
    ".config/sway/config".source = "${dots}/sway/config";
    ".dircolors".source = sources.LS_COLORS.outPath + "/LS_COLORS";
  };
}

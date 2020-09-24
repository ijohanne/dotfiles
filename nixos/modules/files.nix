{ config, ... }:
let
  sources = import ../nix/sources.nix;
  dots = "${config.home.homeDirectory}/.dotfiles";
in {
  imports = [ ./packages.nix ];
  home.file = {
    ".config/sway".source = "${dots}/configs/sway";
    ".dircolors".source = sources.LS_COLORS.outPath + "/LS_COLORS";
  };
}

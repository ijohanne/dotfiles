{ config, ... }:
let
  sources = import ../nix;
  pkgs = import sources.nixpkgs { overlays = [ ]; };
  dots = "${config.home.homeDirectory}/.dotfiles";
in {
  home.file = {
    ".zsh/p10k-lean.zsh".source = "${dots}/configs/zsh/p10k-lean.zsh";
    ".config/sway".source = "${dots}/configs/sway";
    ".dircolors".source = sources.LS_COLORS.outPath + "/LS_COLORS";
  };
}

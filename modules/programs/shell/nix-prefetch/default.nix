{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.nix-prefetch.enable) {
    home.packages = with pkgs; [
      nix-prefetch-docker
      nix-prefetch-git
      nix-prefetch-github
    ];
  };
}


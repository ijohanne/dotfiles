{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.nix-tree.enable) {
    home.packages = [ pkgs.haskellPackages.nix-tree ];
  };
}


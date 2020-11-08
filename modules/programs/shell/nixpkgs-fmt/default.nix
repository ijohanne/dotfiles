{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.nixpkgs-fmt.enable) {
    home.packages = with pkgs; [ nixpkgs-fmt ];
  };
}

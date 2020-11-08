{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.bind.enable) {
    home.packages = with pkgs; [ bind ];
  };
}

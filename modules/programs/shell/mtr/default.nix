{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.mtr.enable) {
    home.packages = with pkgs; [ mtr ];
  };
}


{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.x11.communications.slack.enable) {
    home.packages = with pkgs; [ slack ];
  };

}

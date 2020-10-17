{ pkgs, lib, config, ... }:
with lib; {
  config = lib.mkIf (config.dotfiles.x11.communications.slack) {
    home.packages = with pkgs; [ slack ];
  };

}

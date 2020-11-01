{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.x11.communications.skype) {
    home.packages = with pkgs; [ skype ];
  };

}

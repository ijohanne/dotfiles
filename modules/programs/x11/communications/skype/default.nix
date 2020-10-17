{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.x11.communications.skype) {
    home.packages = with pkgs; [ skype ];
  };

}

{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.x11.communications.keybase
    && config.dotfiles.shell.keybase.enable) {
      home.packages = with pkgs; [ keybase-gui ];
    };

}

{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf
    (config.dotfiles.x11.communications.keybase.enable
      && config.dotfiles.shell.keybase.enable)
    {
      home.packages = with pkgs; [ keybase-gui ];
    };

}

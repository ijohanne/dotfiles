{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf
    config.dotfiles.x11.communications.signal-desktop.enable
    {
      home.packages = with pkgs; [ signal-desktop ];
    };

}

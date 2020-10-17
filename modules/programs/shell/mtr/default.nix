{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.mtr.enable) {
    home.packages = with pkgs; [ mtr ];
  };

}

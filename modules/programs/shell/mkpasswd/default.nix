{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.mkpasswd.enable) {
    home.packages = with pkgs; [ mkpasswd ];
  };

}

{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.fd.enable) {
    home.packages = with pkgs; [ fd ];
  };

}

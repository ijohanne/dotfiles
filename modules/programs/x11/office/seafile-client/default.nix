{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.x11.office.seafile-client) {
    home.packages = with pkgs; [ seafile-client ];
  };
}


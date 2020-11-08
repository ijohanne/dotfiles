{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.x11.office.seafile-client.enable) {
    home.packages = with pkgs; [ seafile-client ];
  };
}

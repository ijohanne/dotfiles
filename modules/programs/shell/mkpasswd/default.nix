{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.mkpasswd.enable) {
    home.packages = with pkgs; [ mkpasswd ];
  };
}


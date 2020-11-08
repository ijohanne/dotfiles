{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.virtualization.docker-compose) {
    home.packages = with pkgs; [ docker-compose ];
  };
}

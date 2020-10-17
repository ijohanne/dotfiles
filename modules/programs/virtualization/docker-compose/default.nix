{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.virtualization.docker-compose) {
    home.packages = with pkgs; [ docker-compose ];
  };
}


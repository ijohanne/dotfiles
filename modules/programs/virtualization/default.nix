{ config, lib, ... }:
with lib;
let cfg = config.dotfiles.virtualization;
in
{
  options.dotfiles.virtualization = {
    docker-compose = mkOption {
      default = false;
      type = types.bool;
      description = "Enable docker compose";
    };
  };

  imports = [ ./docker-compose ];

  config = mkIf (cfg.enable) { dotfiles.virtualization.docker-compose = true; };

}

{ config, lib, ... }:
with lib;
let cfg = config.dotfiles.virtualization;
in {
  options.dotfiles.virtualization = {
    docker-compose = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable docker compose";
    };
  };

  imports = [ ./docker-compose ];

  config =
    lib.mkIf (cfg.enable) { dotfiles.virtualization.docker-compose = true; };

}


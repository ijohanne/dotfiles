{ lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.development-tools.lorri.enable) {
    services.lorri.enable = true;
  };
}


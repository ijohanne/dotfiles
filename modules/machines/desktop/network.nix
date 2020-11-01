{ lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.machines.desktop) {
    networking.networkmanager.enable = true;
  };
}


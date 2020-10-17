{ lib, config, ... }:
with lib; {
  config = lib.mkIf (config.dotfiles.machines.desktop) {
    networking.networkmanager.enable = true;
  };
}


{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.machines.scanners) {
    hardware.sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };
}

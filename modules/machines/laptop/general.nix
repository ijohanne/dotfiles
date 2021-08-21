{ lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.machines.laptop) {
    dotfiles.machines.desktop = true;
  };
}

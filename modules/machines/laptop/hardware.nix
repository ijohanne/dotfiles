{ lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.machines.laptop) {
    services.logind.lidSwitch = "ignore";
  };
}

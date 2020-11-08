{ lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.development-tools.lorri.enable) {
    services.lorri.enable = true;
  };
}

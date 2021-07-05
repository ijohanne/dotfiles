{ config, lib, ... }:
with lib;
let cfg = config.dotfiles.x11.security;
in
{
  options.dotfiles.x11.security = {
    ledger-live-desktop.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable ledger live desktop app";
    };
  };

  imports = [ ./ledger-live-desktop ];

  config = mkIf (cfg.enable) {
    dotfiles.x11.security.ledger-live-desktop.enable = true;
  };

}

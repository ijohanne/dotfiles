{ config, lib, ... }:
with lib;
let cfg = config.dotfiles.browsers;
in {
  options.dotfiles.browsers = {
    firefox.enable = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable firefox app";
    };
  };

  imports = [ ./firefox ];

  config = lib.mkIf (cfg.enable) { dotfiles.browsers.firefox.enable = true; };

}

{ config, lib, ... }:
with lib;
let cfg = config.dotfiles.browsers;
in {
  options.dotfiles.browsers = {
    firefox.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable firefox app";
    };
  };

  imports = [ ./firefox ];

  config = mkIf (cfg.enable) { dotfiles.browsers.firefox.enable = true; };

}

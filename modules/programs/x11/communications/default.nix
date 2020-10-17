{ config, lib, ... }:
with lib;
let cfg = config.dotfiles.x11.communications;
in {
  options.dotfiles.x11.communications = {
    element-desktop = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable element-desktop app";
    };
    slack = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable slack app";
    };
    skype = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable skype app";
    };
  };

  imports = [ ./element-desktop ./skype ./slack ];

  config = lib.mkIf (cfg.enable) {
    dotfiles.x11.communications.element-desktop = true;
    dotfiles.x11.communications.slack = true;
    dotfiles.x11.communications.skype = true;
  };

}


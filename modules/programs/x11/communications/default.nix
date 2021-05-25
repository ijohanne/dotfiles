{ config, lib, ... }:
with lib;
let cfg = config.dotfiles.x11.communications;
in
{
  options.dotfiles.x11.communications = {
    element-desktop.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable element-desktop app";
    };
    slack.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable slack app";
    };
    skype.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable skype app";
    };
    keybase.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable keybase app";
    };
    signal-desktop.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable Signal desktop app";
    };
  };

  imports = [ ./element-desktop ./skype ./slack ./keybase ./signal-desktop ];

  config = mkIf (cfg.enable) {
    dotfiles.x11.communications.element-desktop.enable = true;
    dotfiles.x11.communications.slack.enable = true;
    dotfiles.x11.communications.skype.enable = true;
    dotfiles.x11.communications.keybase.enable = true;
    dotfiles.x11.communications.signal-desktop.enable = true;
  };

}

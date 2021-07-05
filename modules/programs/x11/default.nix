{ lib, config, ... }:
with lib;
let cfg = config.dotfiles.x11;
in
{
  options.dotfiles.x11 = {
    communications.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable X11 communication programs";
    };
    security.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable security programs";
    };
    media.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable X11 media programs";
    };
    terminals.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable X11 terminals programs";
    };
    office.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable X11 office programs";
    };
    fonts.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable X11 fonts";
    };

  };

  imports = [ ./communications ./media ./terminals ./office ./fonts ./security ];

  config = mkMerge [
    (mkIf
      (cfg.communications.enable || cfg.media.enable || cfg.terminals.enable
        || cfg.office.enable)
      {
        home.sessionVariables = {
          LIBVA_DRIVER_NAME = "radeonsi";
          VDPAU_DRIVER = "radeonsi";
          DRI_PRIME = "1";
        };
        dotfiles.x11.fonts.enable = true;
      })
    (mkIf (config.dotfiles.user-settings.face-icon != null) {
      home.file.".face.icon".source = config.dotfiles.user-settings.face-icon;
    })
  ];
}

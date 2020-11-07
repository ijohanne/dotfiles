{ config, lib, ... }:
with lib;
let cfg = config.dotfiles.x11.media;
in {
  options.dotfiles.x11.media = {
    feh.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable feh app";
    };
    spotify.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable spotify app";
    };
    obs-studio.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable obs-studio app";
    };
    pavucontrol.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable pavucontrol app";
    };
    vlc.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable vlc app";
    };
  };

  imports = [ ./feh ./spotify ./obs-studio ./pavucontrol ./vlc ];

  config = mkIf (cfg.enable) {
    dotfiles.x11.media.feh.enable = true;
    dotfiles.x11.media.spotify.enable = true;
    dotfiles.x11.media.obs-studio.enable = true;
    dotfiles.x11.media.pavucontrol.enable = true;
    dotfiles.x11.media.vlc.enable = true;
  };
}


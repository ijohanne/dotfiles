{ config, lib, ... }:
with lib;
let cfg = config.dotfiles.x11.media;
in {
  options.dotfiles.x11.media = {
    feh = mkOption {
      default = false;
      type = types.bool;
      description = "Enable feh app";
    };
    spotify = mkOption {
      default = false;
      type = types.bool;
      description = "Enable spotify app";
    };
    obs-studio = mkOption {
      default = false;
      type = types.bool;
      description = "Enable obs-studio app";
    };
    pavucontrol = mkOption {
      default = false;
      type = types.bool;
      description = "Enable pavucontrol app";
    };
    vlc = mkOption {
      default = false;
      type = types.bool;
      description = "Enable vlc app";
    };
  };

  imports = [ ./feh ./spotify ./obs-studio ./pavucontrol ./vlc ];

  config = mkIf (cfg.enable) {
    dotfiles.x11.media.feh = true;
    dotfiles.x11.media.spotify = true;
    dotfiles.x11.media.obs-studio = true;
    dotfiles.x11.media.pavucontrol = true;
    dotfiles.x11.media.vlc = true;
  };
}


{ config, lib, ... }:
with lib;
let cfg = config.dotfiles.x11.office;
in {
  options.dotfiles.x11.office = {
    libreoffice = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable libreoffice app";
    };
    zathura = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable zathura app";
    };
    thunderbird = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable thunderbird app";
    };
    seafile-client = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable seafile-client app";
    };
  };

  imports = [ ./libreoffice ./zathura ./thunderbird ./seafile-client ];

  config = lib.mkIf (cfg.enable) {
    dotfiles.x11.office.libreoffice = true;
    dotfiles.x11.office.zathura = true;
    dotfiles.x11.office.thunderbird = true;
    dotfiles.x11.office.seafile-client = true;
  };
}


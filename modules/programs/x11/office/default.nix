{ config, lib, ... }:
with lib;
let cfg = config.dotfiles.x11.office;
in
{
  options.dotfiles.x11.office = {
    libreoffice.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable libreoffice app";
    };
    zathura.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable zathura app";
    };
    thunderbird.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable thunderbird app";
    };
    seafile-client.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable seafile-client app";
    };
  };

  imports = [ ./libreoffice ./zathura ./thunderbird ./seafile-client ];

  config = mkIf (cfg.enable) {
    dotfiles.x11.office.libreoffice.enable = true;
    dotfiles.x11.office.zathura.enable = true;
    dotfiles.x11.office.seafile-client.enable = true;
    dotfiles.x11.office.thunderbird.enable = true;
  };
}

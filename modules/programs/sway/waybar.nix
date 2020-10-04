{ config, lib, pkgs, ... }:

let
  cfg = config.services.waybar;
  styles = ./waybar-style.css;
  configFile = pkgs.writeText "waybar-config.json" (builtins.toJSON cfg.config);
in {
  options.services.waybar = with lib; {
    enable = mkEnableOption "waybar";

    config = mkOption {
      type = types.attrs;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.waybar.Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar -c ${configFile} -s ${styles}";
    };
  };
}


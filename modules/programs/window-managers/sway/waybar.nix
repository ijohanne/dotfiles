{ config, lib, pkgs, ... }:

let
  cfg = config.services.waybar;
  styles = ../../../../configs/waybar/waybar-style.css;
  waybar = pkgs.waybar.override ({
    traySupport = true;
    pulseSupport = true;
  });
  configFile = pkgs.writeText "waybar-config.json" (builtins.toJSON cfg.config);
  start-waybar = pkgs.writeShellScriptBin "start-waybar" ''
    export SWAYSOCK=/run/user/$(${pkgs.coreutils}/bin/id -u)/sway-ipc.$(${pkgs.coreutils}/bin/id -u).$(${pkgs.procps}/bin/pgrep -n -f 'sway$').sock
    ${waybar}/bin/waybar "$@"
  '';
in {
  options.services.waybar = with lib; {
    enable = mkEnableOption "waybar";

    config = mkOption { type = types.attrs; };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.waybar.Service = {
      ExecStart =
        "${start-waybar}/bin/start-waybar -c ${configFile} -s ${styles}";
    };
  };
}


{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.yubikey-touch-detector.enable) {
    home.packages = [ pkgs.yubikey-touch-detector ];
    systemd.user = {
      services.yubikey-touch-detector = {
        Unit = {
          Description = "Yubikey touch detector daemon";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };

        Service = {
          ExecStart = "${pkgs.yubikey-touch-detector}/bin/yubikey-touch-detector";
          Environment = [
            "YUBIKEY_TOUCH_DETECTOR_VERBOSE=true"
            "YUBIKEY_TOUCH_DETECTOR_LIBNOTIFY=true"
          ];
        };
      };
      sockets.yubikey-touch-detector = {
        Unit = { Description = "Socket for yubikey touch detector daemon"; };
        Socket = {
          ListenStream = "%t/yubikey-touch-detector.socket";
          RemoveOnStop = "yes";
        };
        Install = { WantedBy = [ "sockets.target" ]; };
      };
    };
  };
}

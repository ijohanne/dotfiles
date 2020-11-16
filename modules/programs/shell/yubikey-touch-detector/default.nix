{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.yubikey-touch-detector.enable) {
    home.packages = [ pkgs.nur-ijohanne.yubikey-touch-detector ];
    systemd.user =
      let
        service-yubikey-touch-detector = pkgs.writeShellScriptBin "start-yubikey-touch-detector" (
          ''
            systemctl --user import-environment
            export PATH="$PATH:$HOME/.nix-profile/bin"
            ${pkgs.nur-ijohanne.yubikey-touch-detector}/bin/yubikey-touch-detector
          ''
        );
      in
      {
        services.yubikey-touch-detector = {
          Unit = { Description = "Yubikey touch detector daemon"; After = [ "graphical.target" ]; };
          Service = {
            ExecStart = "${service-yubikey-touch-detector}/bin/start-yubikey-touch-detector";
            Environment = [
              "YUBIKEY_TOUCH_DETECTOR_VERBOSE=true"
              "YUBIKEY_TOUCH_DETECTOR_LIBNOTIFY=true"
            ];
          };
          Install = { WantedBy = [ "default.target" ]; };
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

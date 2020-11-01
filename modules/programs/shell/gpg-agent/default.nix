{ pkgs, lib, config, ... }:
with lib;
let
  gpg-install-script = pkgs.writeShellScriptBin "gpg-import"
    (concatStringsSep "\n"
      (forEach config.dotfiles.user-settings.gpg.public-keys (elem: ''
        ${lib.getBin pkgs.gnupg}/bin/gpg --import ${elem.key-file}
        ${lib.getBin pkgs.gnupg}/bin/gpg --import-ownertrust << EOF
        ${elem.owner-trust}
        EOF
      '')));
in {
  config = mkIf (config.dotfiles.shell.gpg-agent.enable) {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableExtraSocket = true;
      pinentryFlavor = "curses";
      sshKeys = config.dotfiles.user-settings.gpg.ssh-keys;
      extraConfig = ''
        allow-loopback-pinentry
      '';
    };

    programs.gpg = {
      enable = true;
      settings.pinentry-mode = "loopback";
    };

    programs.fish.shellInit = ''
      set GPG_TTY (tty)
      ${pkgs.gnupg}/bin/gpg-connect-agent updatestartuptty /bye > /dev/null
    '';

    systemd.user.services.gpg-key-import = {
      Unit = { Description = "Import gpg keys"; };
      Install.WantedBy = [ "multi-user.target" ];
      Service = {
        Type = "oneshot";
        ExecStart = "${gpg-install-script}/bin/gpg-import";
      };
    };
  };
}


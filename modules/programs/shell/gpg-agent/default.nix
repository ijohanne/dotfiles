{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.gpg-agent.enable) {
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
  };
}


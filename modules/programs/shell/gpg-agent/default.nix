{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.gpg-agent.enable) {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableExtraSocket = true;
      pinentryFlavor = "curses";
      sshKeys = [ "155285F1319ACA9CA9A9CA3E258C23D13AE38CF3" ];
    };
    programs.gpg.enable = true;
    programs.fish.shellInit = ''
      set GPG_TTY (tty)
      ${pkgs.gnupg}/bin/gpg-connect-agent updatestartuptty /bye > /dev/null
    '';
  };
}


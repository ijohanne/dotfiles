{ pkgs, lib, config, ... }:
with lib;
let
  gpg-install-script = pkgs.writeShellScriptBin "gpg-import" (
    ''
      ${pkgs.coreutils}/bin/chmod 0700 $HOME/.gnupg
    '' + (
      concatStringsSep "\n"
        (
          forEach config.dotfiles.user-settings.gpg.public-keys (
            elem: ''
              ${lib.getBin pkgs.gnupg}/bin/gpg --import ${elem.key-file}
              ${lib.getBin pkgs.gnupg}/bin/gpg --import-ownertrust << EOF
              ${elem.owner-trust}
              EOF
            ''
          )
        )
    )
  );
  udev-yubikey-scripts = pkgs.writeShellScriptBin "clean-card-private-keys" ''
    keygrips=$(
      ${lib.getBin pkgs.gnupg}/bin/gpg-connect-agent 'keyinfo --list' /bye 2>/dev/null \
      | grep -v OK \
      | awk '{if ($4 == "T") { print $3 ".key" }}')
    for f in $keygrips; do
      rm -v ~/.gnupg/private-keys-v1.d/$f
      done
    ${lib.getBin pkgs.gnupg}/bin/gpg --card-status
  '';
in
{
  config = mkIf (config.dotfiles.shell.gpg.enable) {
    services.gpg-agent =
      mkIf (config.dotfiles.shell.gpg-agent.enable)
        (
          mkMerge [
            (mkIf config.dotfiles.shell.gpg-agent.desktop {
              enableSshSupport = true;
              enableExtraSocket = true;
              pinentryFlavor = "gtk2";
              sshKeys = config.dotfiles.user-settings.gpg.ssh-keys;
            })
            {
              enable = true;
              extraConfig = ''
                allow-loopback-pinentry
              '';
            }
          ]);

    home.packages = optionals (config.dotfiles.shell.gpg-agent.desktop) (with pkgs;
      [ gpgme gpgme.dev ]);

    programs.gpg = {
      enable = true;
      settings.pinentry-mode = "loopback";
    };

    programs.fish.shellAliases = mkIf config.dotfiles.shell.gpg-agent.enable {
      "gpg" = "gpg --no-autostart";
    };

    programs.fish.shellInit = mkMerge [
      (
        ''${pkgs.gnupg}/bin/gpgconf --create-socketdir''
      )
      (mkIf (config.dotfiles.shell.gpg-agent.enable) ''
        set GPG_TTY (tty)
        ${pkgs.gnupg}/bin/gpg-connect-agent updatestartuptty /bye > /dev/null
      '')
    ];

    systemd.user.services = (mkMerge [
      {
        gpg-key-import =
          {
            Unit = { Description = "Import gpg keys"; };
            Install.WantedBy = [ "multi-user.target" ];
            Service = {
              Type = "oneshot";
              ExecStart = "${gpg-install-script}/bin/gpg-import";
            };
          };
      }
      (mkIf config.dotfiles.shell.gpg-agent.desktop {
        yubikey-card-changed = {
          Unit = {
            Description = "Remove previous cached keycard, reimport from card, and cycle GPG-agent";
          };
          Service = {
            Type = "oneshot";
            ExecStart = "${udev-yubikey-scripts}/bin/clean-card-private-keys";
          };
        };
      })
    ]);
  };
}

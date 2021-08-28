{ config, pkgs, lib, ... }:
{
  services.gitea = {
    enable = true;
    user = "git";
    cookieSecure = true;
    domain = "git.unixpimps.net";
    rootUrl = "https://git.unixpimps.net/";
    database = {
      type = "mysql";
      user = "git";
      name = "gitunixpimpsnet";
    };
    disableRegistration = true;
    ssh.enable = true;
    lfs.enable = true;
    settings = {
      repository = {
        DISABLE_HTTP_GIT = false;
        USE_COMPAT_SSH_URI = true;
      };
      security = {
        INSTALL_LOCK = true;
        COOKIE_USERNAME = "gitea_username";
        COOKIE_REMEMBER_NAME = "gitea_userauth";
      };
      metrics = {
        ENABLED = true;
      };
    };
    dump = {
      enable = true;
      interval = "03:00";
    };
  };

  services.borgbackup.jobs.services.paths = lib.mkAfter [ config.services.gitea.dump.backupDir ];
  systemd.services.gitea-dump.preStart = ''
    ${pkgs.findutils}/bin/find ${config.services.gitea.dump.backupDir} -type f -mtime +7 -name '*.zip' -execdir rm -- '{}' \;
  '';

  services.nginx.virtualHosts."git.unixpimps.net" = {
    forceSSL = true;
    enableACME = true;
    locations."/".proxyPass = "http://127.0.0.1:3000/";
  };

  users.users.git = {
    description = "Gitea Service";
    isNormalUser = true;
    home = config.services.gitea.stateDir;
    createHome = true;
    useDefaultShell = true;
  };
}

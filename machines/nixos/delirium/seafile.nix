{ secrets, config, pkgs, lib, ... }:
let
  pr_119719 = builtins.fetchTarball {
    name = "nixos-pr_119719";
    url = "https://api.github.com/repos/greizgh/nixpkgs/tarball/seafile";
    sha256 = "1xs075sh741ra2479id9q3yms93v3i0j1rfmvxvc563wbxdpfs7r";
  };
in
{
  containers = {
    seafile = {
      privateNetwork = true;
      autoStart = true;
      ephemeral = false;
      nixpkgs = pr_119719;
      hostAddress = "192.168.100.2";
      localAddress = "192.168.100.11";
      bindMounts =
        {
          "/var/lib/seafile" = {
            hostPath = "/var/data/seafile";
            isReadOnly = false;
          };
        };
      config = { config, pkgs, ... }: {
        services.kresd.enable = true;
        services.seafile = {
          enable = true;
          ccnetSettings.General.SERVICE_URL = "https://seafile.unixpimps.net";
          seahubExtraConf = ''
            CSRF_TRUSTED_ORIGINS = ['seafile.unixpimps.net']
          '';
          adminEmail = "sysops@unixpimps.net";
          initialAdminPassword = secrets.seafile.admin;
        };
        networking.firewall.allowedTCPPorts = [ 80 ];
        services.nginx = {
          enable = true;
          virtualHosts."seafile.unixpimps.net" = {
            locations."/" = {
              proxyPass = "http://unix:/run/seahub/gunicorn.sock";
              extraConfig = ''
                proxy_set_header X-Forwarded-Proto https;
              '';
            };
            locations."/seafhttp" = {
              proxyPass = "http://127.0.0.1:8082";
              extraConfig = ''
                rewrite ^/seafhttp(.*)$ $1 break;
                client_max_body_size 0;
                proxy_connect_timeout  36000s;
                proxy_set_header X-Forwarded-Proto https;
                proxy_set_header Host $host:$server_port;
                proxy_read_timeout  36000s;
                proxy_send_timeout  36000s;
                send_timeout  36000s;
                proxy_http_version 1.1;
              '';
            };
          };
        };
      };
    };
  };

  services.borgbackup.jobs.seafile = {
    paths = "/var/backup";
    encryption.mode = "none";
    repo = "/var/borgbackup/seafile";
    startAt = "*-*-* 04:00:00";
  };

  systemd.services.borgbackup-job-seafile = {
    preStart = lib.mkBefore ''
      systemctl stop container@seafile
    '';
    postStop = ''
      systemctl start container@seafile
    '';
  };

  networking.nat.internalInterfaces = [ "ve-seafile" ];

  services.nginx = {
    virtualHosts = {
      "seafile.unixpimps.net" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://192.168.100.11";
            extraConfig = ''
              client_max_body_size 0;
              proxy_read_timeout 310s;
            '';
          };
        };
      };
    };
  };
}

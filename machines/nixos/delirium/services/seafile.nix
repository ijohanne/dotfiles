{ secrets, config, pkgs, lib, ... }:
let
  pr_119719 = builtins.fetchTarball {
    name = "nixos-pr_119719";
    url = "https://api.github.com/repos/greizgh/nixpkgs/tarball/seafile";
    sha256 = "0pysyls3c394b4p434hmcvn0xkyh0d02hbsza903lqx81146957g";
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
        nixpkgs.overlays = [
          (self: super: {
            python39 =
              super.python39.override
                {
                  packageOverrides = self: super: {
                    django-webpack-loader = super.django-webpack-loader.overrideAttrs (_: {
                      version = "0.7.0";
                      src = super.pkgs.python39Packages.fetchPypi {
                        pname = "django-webpack-loader";
                        version = "0.7.0";
                        sha256 = "0izl6bibhz3v538ad5hl13lfr6kvprf62rcl77wq2i5538h8hg3s";
                      };
                    });
                  };
                };
            python39Packages = self.python39.pkgs;
          })
        ];
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
    prune.keep = {
      daily = 7;
      weekly = 2;
      monthly = 1;
    };
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

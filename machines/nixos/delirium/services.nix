{ secrets, config, pkgs, lib, ... }:

let
  ngx_http_geoip2_module = pkgs.stdenv.mkDerivation rec {
    name = "ngx_http_geoip2_module-a28ceff";
    src = pkgs.fetchzip {
      url = "https://github.com/leev/ngx_http_geoip2_module/archive/a28ceffdeffb2b8ec2896bd1192a87f4f2c7a12a.zip";
      sha256 = "0ba1bjnkskd241ix7ax27n3d9klpymigm0wdjgd4yhlsgbxsxvdx";
    };
    installPhase = ''
      mkdir $out
      cp *.c config $out/
    '';
    fixupPhase = "";
  };
  geolite2UpdaterConfig = rec {
    databaseDir = "/var/lib/geoip-databases";
    interval = "weekly";
    geoip-updater = pkgs.writeScriptBin "geoip-updater" ''
      #!${pkgs.runtimeShell}
      skipExisting=0
      for arg in "$@"; do
        case "$arg" in
          --skip-existing)
            skipExisting=1
            echo "Option --skip-existing is set: not updating existing databases"
            ;;
          *)
            echo "Unknown argument: $arg";;
        esac
      done
      cd ${databaseDir}
      for dbName in "GeoLite2-City" "GeoLite2-Country" "GeoLite2-ASN"; do
        dbBaseUrl="https://download.maxmind.com/app/geoip_download?edition_id=$dbName&license_key=${secrets.maxmind.apiKey}&suffix=tar.gz";
        if [ "$skipExisting" -eq 1 -a -f $dbName.mmdb ]; then
          echo "Skipping existing file: $dbName.mmdb"
          continue
        fi
        ${pkgs.curl}/bin/curl -o $dbName.tar.gz $dbBaseUrl
        ${pkgs.gzip}/bin/gzip -cd $dbName.tar.gz | ${pkgs.gnutar}/bin/tar xvf -
        mv $dbName\_*/$dbName.mmdb .
        rm -rfv $dbName\_*/ $dbName.tar.gz
      done
    '';
  };
in
{
  services.openssh.permitRootLogin = "prohibit-password";
  services.xserver = { enable = false; };
  services.openssh.enable = true;
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    package = pkgs.nginxMainline.overrideAttrs (oldAttrs: rec {
      configureFlags = oldAttrs.configureFlags ++ [ "--add-module=${ngx_http_geoip2_module}" ];
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.libmaxminddb ];
    });
    appendHttpConfig = ''
      geoip2 /var/lib/geoip-databases/GeoLite2-Country.mmdb {
        auto_reload 5m;
        $geoip2_metadata_country_build metadata build_epoch;
        $geoip2_data_country_code country iso_code;
        $geoip2_data_country_name country names en;
        $geoip2_data_continent_code continent code;
        $geoip2_data_continent_name continent names en;
      }

      geoip2 /var/lib/geoip-databases/GeoLite2-City.mmdb {
          auto_reload 5m;
          $geoip2_data_city_name city names en;
          $geoip2_data_lat location latitude;
          $geoip2_data_lon location longitude;
      }

      geoip2 /var/lib/geoip-databases/GeoLite2-ASN.mmdb {
          auto_reload 5m;
          $geoip2_data_asn autonomous_system_number;
          $geoip2_data_asorg autonomous_system_organization;
      }
      fastcgi_param MM_CONTINENT_CODE $geoip2_data_continent_code;
      fastcgi_param MM_CONTINENT_NAME $geoip2_data_continent_name;
      fastcgi_param MM_COUNTRY_CODE $geoip2_data_country_code;
      fastcgi_param MM_COUNTRY_NAME $geoip2_data_country_name;
      fastcgi_param MM_CITY_NAME    $geoip2_data_city_name;
      fastcgi_param MM_LATITUDE $geoip2_data_lat;
      fastcgi_param MM_LONGITUDE $geoip2_data_lon;
      fastcgi_param MM_ISP $geoip2_data_asorg;
    '';
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    bind = "0.0.0.0";
  };

  networking.firewall.interfaces.docker0 = {
    allowedTCPPorts = [ 3306 ];
    allowedUDPPorts = [ 3306 ];
  };

  users.users.geoip = {
    isSystemUser = true;
    group = "srv";
    description = "GeoIP database updater";
  };

  systemd.timers.geoip-updater =
    {
      description = "GeoIP Updater Timer";
      partOf = [ "geoip-updater.service" ];
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = geolite2UpdaterConfig.interval;
      timerConfig.Persistent = "true";
      timerConfig.RandomizedDelaySec = "3600";
    };

  systemd.services.geoip-updater = {
    description = "GeoIP Updater";
    after = [ "network-online.target" "nss-lookup.target" ];
    wants = [ "network-online.target" ];
    preStart = with geolite2UpdaterConfig; ''
      mkdir -p "${databaseDir}"
      chmod 755 "${databaseDir}"
      chown geoip:srv "${databaseDir}"
    '';
    serviceConfig = {
      ExecStart = "${geolite2UpdaterConfig.geoip-updater}/bin/geoip-updater";
      User = "geoip";
      PermissionsStartOnly = true;
    };
  };

  systemd.services.geoip-updater-setup = {
    description = "GeoIP Updater Setup";
    after = [ "network-online.target" "nss-lookup.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    conflicts = [ "geoip-updater.service" ];
    preStart = with geolite2UpdaterConfig; ''
      mkdir -p "${databaseDir}"
      chmod 755 "${databaseDir}"
      chown geoip:srv "${databaseDir}"
    '';
    serviceConfig = {
      ExecStart = "${geolite2UpdaterConfig.geoip-updater}/bin/geoip-updater --skip-existing";
      User = "geoip";
      PermissionsStartOnly = true;
      # So it won't be (needlessly) restarted:
      RemainAfterExit = true;
    };
  };
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "teamspeak-server"
  ];

  services.teamspeak3 = {
    enable = true;
  };

  containers = {
    vsftpd = {
      privateNetwork = false;
      autoStart = true;
      ephemeral = true;
      bindMounts =
        {
          "/var/data" = {
            hostPath = "/var/data/torrent";
            isReadOnly = false;
          };
          "/var/vsftpd/vsftpd.cert.pem" = {
            hostPath = "/var/lib/acme/ftp.unixpimps.net/cert.pem";
          };
          "/var/vsftpd/vsftpd.key.pem" = {
            hostPath = "/var/lib/acme/ftp.unixpimps.net/key.pem";
          };
        };
      config = { config, pkgs, ... }: {
        systemd.tmpfiles.rules = [
          "d /var/data 0755 vsftpd nogroup"
        ] ++ (pkgs.lib.attrValues (pkgs.lib.mapAttrs (name: value: "d /var/data/${name} 0755 vsftpd nogroup") secrets.vsftpd))
        ++ (pkgs.lib.attrValues (pkgs.lib.mapAttrs (name: value: "d /var/data/${name}/Downloads 0755 vsftpd nogroup") secrets.vsftpd));
        services.vsftpd =
          let
            vsftpd-users = pkgs.writeText "vsftpd-users" (pkgs.lib.concatStrings (pkgs.lib.attrValues (pkgs.lib.mapAttrs (name: value: "${name}\n${value}\n") secrets.vsftpd)));
            vsftpd-users-db = pkgs.stdenv.mkDerivation {
              name = "vsftpd-users-db";
              phases = [ "installPhase" "fixupPhase" ];
              installPhase = ''
                mkdir -p $out;
                ${pkgs.db4}/bin/db_load -T -t hash -f ${vsftpd-users} $out/userDb.db
              '';
            };
          in
          {
            enable = true;
            enableVirtualUsers = true;
            userDbPath = "${vsftpd-users-db}/userDb";
            chrootlocalUser = true;
            anonymousUser = false;
            anonymousUserNoPassword = false;
            localUsers = true;
            writeEnable = true;
            allowWriteableChroot = true;
            localRoot = "/var/data/$USER";
            userlistDeny = true;
            extraConfig = ''
                    user_sub_token=$USER
                    pasv_enable=Yes
                    pasv_min_port=51000
                    pasv_max_port=51999
              pasv_promiscuous=YES
                    port_promiscuous=YES
            '';
            forceLocalLoginsSSL = true;
            forceLocalDataSSL = true;
            rsaCertFile = "/var/vsftpd/vsftpd.cert.pem";
            rsaKeyFile = "/var/vsftpd/vsftpd.key.pem";
          };
      };
    };
  };

  services.nginx.virtualHosts = {
    "ftp.unixpimps.net" = {
      enableACME = true;
      locations."/" = {
        extraConfig = ''
          rewrite ^ https://unixpimps.net$request_uri;
        '';
      };
    };
  };

  security.acme.certs."ftp.unixpimps.net" = {
    keyType = "rsa2048";
    postRun = ''
      systemctl restart container@vsftpd
    '';
  };

  services.nginx.virtualHosts."git.unixpimps.net" = {
    forceSSL = true;
    enableACME = true;
    locations."/".proxyPass = "http://127.0.0.1:3000/";
  };

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
    };
  };

  users.users.git = {
    description = "Gitea Service";
    isNormalUser = true;
    home = config.services.gitea.stateDir;
    createHome = true;
    useDefaultShell = true;
  };

  networking.firewall =
    {
      allowedTCPPorts = [
        # Web ports
        80
        443
        # SSH
        22
        # vsFTPd
        20
        21
      ];
      allowedUDPPorts = [
        # Teamspeak3
        9987
        9999
        9988
        30033
        10011
      ];
      allowedTCPPortRanges = [
        # vsFTPd
        { from = 51000; to = 51999; }
      ];
    };

}

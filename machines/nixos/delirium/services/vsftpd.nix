{ secrets, config, pkgs, lib, ... }:
{
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
            localRoot = "/var/data/$USER/Downloads";
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

  networking.firewall =
    {
      allowedTCPPorts = [
        20
        21
      ];
      allowedTCPPortRanges = [
        { from = 51000; to = 51999; }
      ];
    };
}

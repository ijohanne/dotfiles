{ secrets, config, pkgs, lib, ... }:
let
  backupScript = pkgs.fetchFromGitHub {
    owner = "danielebailo";
    repo = "couchdb-dump";
    rev = "master";
    sha256 = "05zl8k7ixvwk5ib7x9qjryd38g2p4vhgw6n0pgf9p4kfznvxn6vw";
  };
  couchdbBackupScript = ''
    set -o pipefail
    mkdir -p /var/backup/opsplaza
    rm /var/backup/opsplaza/themailer-couchdb.json
    ${pkgs.bash}/bin/bash ${backupScript}/couchdb-dump.sh -b -H 127.0.0.1 -d themailer \
      -f /var/backup/opsplaza/themailer-couchdb.json
  '';
  jbossServerConfig = ./jboss/standalone.xml;
  jbossArchive = pkgs.fetchzip {
    url = "https://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip";
    sha256 = "12wbp71fqg5wr9vlv7x70idjcpa29l8mbx7k7ipqyinjlzdalblp";
  };
  themailerWar = ./jboss/rage-themailer.war;
  themailerJdk = ./jboss/jdk1.7.0_02;
  fedora31 = pkgs.dockerTools.pullImage {
    imageName = "fedora";
    imageDigest = "sha256:444773966064dcc3c268d8b496e76dbbbb49d16586d5a969c4082579e6b77616";
    sha256 = "03hs10jb6c7qj10wlv24wk43yp0ldgizrfrg1d857b065nlqxc4v";
    finalImageTag = "31";
    finalImageName = "fedora";
  };

  themailerImage = pkgs.dockerTools.buildImage {
    name = "themailer";
    tag = "latest";
    fromImage = fedora31;
    runAsRoot = ''
      cp -R ${jbossArchive} /opt/jboss-as-7.1.1.Final
      JBOSS="/opt/jboss-as-7.1.1.Final/standalone"
      mkdir -p $JBOSS/configuration
      mkdir -p $JBOSS/deployments
      cp ${jbossServerConfig} $JBOSS/configuration/standalone.xml
      cp ${themailerWar} $JBOSS/deployments/rage-themailer.war
      chmod +x /opt/jboss-as-7.1.1.Final/bin/run.sh
      cp -R ${themailerJdk} /opt/jdk1.7.0_02
    '';
    config = {
      Cmd = [ "/opt/jboss-as-7.1.1.Final/bin/standalone.sh" "-c" "standalone.xml" "-b" "0.0.0.0" ];
      Env = [
        "JBOSS_HOME=/opt/jboss-as-7.1.1.Final"
        "JAVA_HOME=/opt/jdk1.7.0_02"
      ];
    };
  };
in
{
  services.nginx = {
    virtualHosts = lib.mkMerge [
      {
        "${secrets.opsplaza.themailerVhost}" = {
          http2 = true;
          forceSSL = true;
          enableACME = true;
          locations = {
            "/" = {
              extraConfig = ''
                proxy_set_header   Host             themailer.ragetech.dk;
                proxy_set_header   X-Real-IP        $remote_addr;
                proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
                proxy_set_header   X-Proxy-Proto  http;
              '';
              proxyPass = "http://127.0.0.1:12001";
            };
          };
        };
      }
      (lib.genAttrs secrets.opsplaza.agentServers
        (site:
          lib.mkMerge [
            {
              http2 = true;
              forceSSL = true;
              enableACME = true;
              locations = {
                "/" = {
                  extraConfig = ''
                    proxy_set_header   Host             ${site};
                    proxy_set_header   X-Real-IP        $remote_addr;
                    proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
                    proxy_set_header   X-Proxy-Proto  http;
                  '';
                  proxyPass = "http://127.0.0.1:5000";
                };
              };
            }
          ]
        ))
    ];
  };
  virtualisation.oci-containers.containers =
    {
      couchdb = {
        autoStart = true;
        image = "couchdb:2.3.1";
        ports = [ "127.0.0.1:5984:5984" ];
        volumes = [ "/var/opsplaza/couchdb:/opt/couchdb/data" ];
        extraOptions = [ "--network=opsplaza-br" ];
      };
      themailer = {
        autoStart = true;
        image = "themailer:latest";
        imageFile = themailerImage;
        ports = [ "127.0.0.1:12001:8080" ];
        extraOptions = [ "--network=opsplaza-br" ];
      };
      themailerpostfix = {
        autoStart = true;
        image = "juanluisbaptiste/postfix";
        extraOptions = [ "--network=opsplaza-br" ];
        environment = {
          SMTP_SERVER = "delirium.unixpimps.net";
          SMTP_PORT = "587";
          SMTP_USERNAME = "themailer@unixpimps.net";
          SMTP_PASSWORD = "${secrets.opsplaza.smtpPass}";
          SERVER_HOSTNAME = "themailer.unixpimps.net";
        };
      };
    };

  systemd.tmpfiles.rules = [
    "d /var/opsplaza/couchdb 0777 root root"
  ];

  services.borgbackup.jobs.services.paths = lib.mkAfter
    [ "/etc/nixos/hosted/opsplaza/jboss" ];

  systemd = {
    timers.opsplaza-couchdb-backup = {
      description = "Opsplaza couchdb backup timer";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "02:00:00";
        AccuracySec = "5m";
        Unit = "opsplaza-couchdb-backup.service";
      };
    };
    services = {
      opsplaza-couchdb-backup = {
        description = "Opsplaza couchdb backup service";
        enable = true;
        script = couchdbBackupScript;
        path = with pkgs; [ gnused curl file gawk coreutils ];
      };
      init-opsplaza-docker-network = {
        description = "Create the network bridge opsplaza-br for opsplaza containers.";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" "docker-couchdb.service" "docker-themailer.service" "docker-themailerpostfix.service" ];

        serviceConfig.Type = "oneshot";
        script =
          let dockercli = "${config.virtualisation.docker.package}/bin/docker";
          in
          ''
            # Put a true at the end to prevent getting non-zero return code, which will
            # crash the whole service.
            check=$(${dockercli} network ls | grep "opsplaza-br" || true)
            if [ -z "$check" ]; then
              ${dockercli} network create opsplaza-br
            else
              echo "opsplaza-br already exists in docker"
            fi
          '';
      };
    };

  };

}

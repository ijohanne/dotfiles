{ pkgs, config, secrets, ... }:
let
  ts3exporter = pkgs.buildGoModule rec {
    name = "ts3exporter";

    src = pkgs.fetchFromGitHub {
      owner = "ijohanne";
      repo = "ts3exporter";
      rev = "e8d0a46ea0e73cfc7924685006a19a2b872673e3";
      sha256 = "187sxyiglm728s113cb0kh8jldibwaw7mk6h2f97jpl2s9svccbi";
    };
    vendorSha256 = "15jzxm4yviv1pjhb9zjmy0zccn28qcdwsk1pkx3x8yl0h2hdxpgf";
    # skips tests with external dependencies, e.g. on mysqld
    checkFlags = [ "-short" ];
  };
in
{
  services.prometheus.exporters.rspamd.enable = true;
  services.rspamd = {
    workers.controller.bindSockets = [
      {
        socket = "/run/rspamd/worker-controller.sock";
        mode = "0666";
      }
      "0.0.0.0:11334"
    ];
  };

  services.prometheus.exporters.smokeping = {
    enable = true;
    hosts = [
      "google.com"
      "8.8.8.8"
      "141.94.130.254"
    ];
  };

  services.prometheus.exporters.nginx.enable = true;

  services.prometheus.exporters.dovecot = {
    user = config.services.dovecot2.user;
    group = config.services.dovecot2.group;
    enable = true;
    scopes = [ "user" "global" ];
    socketPath = "/var/run/dovecot2/old-stats";
  };

  services.dovecot2 = {
    mailPlugins.globally.enable = [ "old_stats" ];
    extraConfig = ''
      service old-stats {
        unix_listener old-stats {
          user = ${config.services.dovecot2.user}
          group = ${config.services.dovecot2.group}
          mode = 0660
        }
        fifo_listener old-stats-mail {
          mode = 0660
          user = ${config.services.dovecot2.user}
          group = ${config.services.dovecot2.group}
        }
        fifo_listener old-stats-user {
          mode = 0660
          user = ${config.services.dovecot2.user}
          group = ${config.services.dovecot2.group}
        }
      }
      plugin {
        old_stats_refresh = 30 secs
        old_stats_track_cmds = yes
      }
    '';
  };

  services.prometheus.exporters.node.enable = true;

  services.prometheus.exporters.postgres = {
    enable = true;
    runAsLocalSuperUser = true;
  };

  services.prometheus.exporters.redis.enable = true;
  services.prometheus.exporters.systemd.enable = true;
  services.prometheus.exporters.postfix.enable = true;

  services.matrix-synapse = {
    enable_metrics = true;
    listeners = [
      {
        bind_address = "127.0.0.1";
        port = 9092;
        tls = false;
        resources = [{ names = [ "metrics" ]; compress = false; }];
      }
    ];
  };

  users.users."mysqld-exporter" = {
    description = "Prometheus myslqd exporter service user";
    isSystemUser = true;
    group = "mysqld-exporter";
  };
  users.groups."mysqld-exporter" = { };
  systemd.services."prometheus-mysqld-exporter" = {
    environment = {
      DATA_SOURCE_NAME = "exporter:${secrets.mariadb.exporter}@(127.0.0.1:3306)/";
    };
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.PrivateTmp = true;
    serviceConfig.WorkingDirectory = /tmp;
    serviceConfig.DynamicUser = false;
    serviceConfig.User = "mysqld-exporter";
    serviceConfig.Group = "mysqld-exporter";
    serviceConfig.ExecStart = ''
      ${pkgs.prometheus-mysqld-exporter}/bin/mysqld_exporter \
        --web.listen-address 127.0.0.1:9104
        --web.telemetry-path "/metrics"
    '';
  };

  services.mysql = {
    ensureUsers = [
      {
        name = "exporter";
        ensurePermissions = {
          "*.*" = "PROCESS,REPLICATION CLIENT,SELECT";
        };
      }
    ];
  };

  systemd.services.prometheus-exporter-setdbpass = {
    description = "MySQL database password setup (prometheus exporter)";
    wants = [ "mysql.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.mariadb}/bin/mysql -uroot -e "GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO exporter@localhost IDENTIFIED BY '${secrets.mariadb.exporter}';"
      '';
      User = "root";
      PermissionsStartOnly = true;
      RemainAfterExit = true;
    };
  };

  users.users."teamspeak3-exporter" = {
    description = "Prometheus TeamSpeak3 exporter service user";
    isSystemUser = true;
    group = "teamspeak3-exporter";
  };
  users.groups."teamspeak3-exporter" = { };
  systemd.services."prometheus-teamspeak3-exporter" = {
    environment = {
      SERVERQUERY_PASSWORD = secrets.teamspeak3.serveradmin;
    };
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.PrivateTmp = true;
    serviceConfig.WorkingDirectory = /tmp;
    serviceConfig.DynamicUser = false;
    serviceConfig.User = "teamspeak3-exporter";
    serviceConfig.Group = "teamspeak3-exporter";
    serviceConfig.ExecStart = ''
      ${ts3exporter}/bin/ts3exporter \
        -enablechannelmetrics \
        -ignorefloodlimits \
        -listen 127.0.0.1:9189 \
        -remote 127.0.0.1:10011 \
        -user serveradmin
    '';
  };

  systemd.services.prometheus-docker-exporter = {
    enable = config.services.prometheus.enable;
    description = "Docker exporter for Prometheus";
    after = [ "docker.service" ];
    bindsTo = [ "docker.service" ];
    wantedBy = [ "prometheus.service" ];
    serviceConfig = {
      Restart = "always";
      ExecStartPre = [
        "-${pkgs.docker}/bin/docker stop prometheus_docker_exporter"
        "-${pkgs.docker}/bin/docker rm prometheus_docker_exporter"
        "${pkgs.docker}/bin/docker pull prometheusnet/docker_exporter"
      ];
      ExecStart = "${pkgs.docker}/bin/docker run --rm --name prometheus_docker_exporter --volume \"/var/run/docker.sock\":\"/var/run/docker.sock\" --publish 9417:9417 prometheusnet/docker_exporter";
    };
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "rspamd";
      honor_labels = true;
      metrics_path = "/probe";
      params = {
        target = [ "http://delirium.unixpimps.net:11334/stat" ];
      };
      static_configs = [{
        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.rspamd.port}" ];
      }];
    }
    {
      job_name = "dovecot";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.dovecot.port}" ];
      }];
    }
    {
      job_name = "postfix";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.postfix.port}" ];
      }];
    }
    {
      job_name = "smokeping";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.smokeping.port}" ];
      }];
    }
    {
      job_name = "node";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
      }];
    }
    {
      job_name = "postgres";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.postgres.port}" ];
      }];
    }
    {
      job_name = "redis";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.redis.port}" ];
      }];
    }
    {
      job_name = "systemd";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.systemd.port}" ];
      }];
    }
    {
      job_name = "nginx";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.nginx.port}" ];
      }];
    }
    {
      job_name = "teamspeak3";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:9189" ];
      }];
    }
    {
      job_name = "mariadb";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:9104" ];
      }];
    }
    {
      job_name = "docker";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:9417" ];
      }];
    }
    {
      job_name = "gitea";
      honor_labels = true;
      scheme = "https";
      static_configs = [{
        targets = [ "git.unixpimps.net" ];
      }];
    }

    {
      job_name = "synapse";
      honor_labels = true;
      metrics_path = "/_synapse/metrics";
      static_configs = [{
        targets = [ "127.0.0.1:9092" ];
      }];
    }
  ];
}

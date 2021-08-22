{ pkgs, config, secrets, ... }:
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
      job_name = "mariadb";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:9104" ];
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

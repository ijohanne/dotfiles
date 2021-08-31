{ pkgs, config, secrets }:
{
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
          "*.*" = "PROCESS,REPLICATION CLIENT,SELECT, SUPER, SLAVE MONITOR";
        };
      }
    ];
  };

  systemd.services.prometheus-exporter-setdbpass = {
    description = "MySQL database password setup (prometheus exporter)";
    wants = [ "mysql.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecPreStart = ''${pkgs.coreutils}/bin/sleep 10'';
      ExecStart = ''
        ${pkgs.mariadb}/bin/mysql -uroot -e "GRANT PROCESS, REPLICATION CLIENT, SELECT, SUPER, SLAVE MONITOR ON *.* TO exporter@localhost IDENTIFIED BY '${secrets.mariadb.exporter}';"
      '';
      User = "root";
      PermissionsStartOnly = true;
      RemainAfterExit = true;
    };
  };

  services.prometheus = {
    rules = [
      ''
        - name: mariadb
          rules:
            - alert: MysqlDown
              expr: mysql_up == 0
              for: 0m
              labels:
                severity: critical
              annotations:
                summary: MySQL down (instance {{ $labels.instance }})
                description: "MySQL instance is down on {{ $labels.instance }}\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: MysqlTooManyConnections(>80%)
              expr: avg by (instance) (rate(mysql_global_status_threads_connected[1m])) / avg by (instance) (mysql_global_variables_max_connections) * 100 > 80
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: MySQL too many connections (> 80%) (instance {{ $labels.instance }})
                description: "More than 80% of MySQL connections are in use on {{ $labels.instance }}\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: MysqlHighThreadsRunning
              expr: avg by (instance) (rate(mysql_global_status_threads_running[1m])) / avg by (instance) (mysql_global_variables_max_connections) * 100 > 60
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: MySQL high threads running (instance {{ $labels.instance }})
                description: "More than 60% of MySQL connections are in running state on {{ $labels.instance }}\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: MysqlSlowQueries
              expr: increase(mysql_global_status_slow_queries[1m]) > 0
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: MySQL slow queries (instance {{ $labels.instance }})
                description: "MySQL server mysql has some new slow query.\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: MysqlInnodbLogWaits
              expr: rate(mysql_global_status_innodb_log_waits[15m]) > 10
              for: 0m
              labels:
                severity: warning
              annotations:
                summary: MySQL InnoDB log waits (instance {{ $labels.instance }})
                description: "MySQL innodb log writes stalling\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"''
    ];
    scrapeConfigs = [
      {
        job_name = "mariadb";
        honor_labels = true;
        static_configs = [{
          targets = [ "127.0.0.1:9104" ];
        }];
      }
    ];
  };
}

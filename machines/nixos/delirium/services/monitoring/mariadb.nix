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

  services.prometheus.scrapeConfigs = [
    {
      job_name = "mariadb";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:9104" ];
      }];
    }
  ];
}

{ secrets, config, pkgs, lib, ... }:
let
  dumpScript = pkgs.writeScriptBin "prometheus-dump" ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.findutils}/bin/find  /var/lib/${config.services.prometheus.stateDir}/data/snapshots -mindepth 1 -maxdepth 1 -type d -mtime +7 -exec rm -rf {} \;
    ${pkgs.curl}/bin/curl -XPOST http://localhost:9001/api/v1/admin/tsdb/snapshot
  '';
in
{
  services.prometheus = {
    enable = true;
    port = 9001;
    pushgateway = {
      enable = true;
      web.listen-address = "127.0.0.1:9091";
    };
    extraFlags = [ "--web.enable-admin-api" ];
    globalConfig = {
      scrape_interval = "15s";
    };
    scrapeConfigs = [
      {
        job_name = "pushgateway";
        honor_labels = true;
        static_configs = [{
          targets = [ "${config.services.prometheus.pushgateway.web.listen-address}" ];
        }];
      }
    ];
  };

  services.grafana = {
    enable = true;
    domain = "grafana.unixpimps.net";
    port = 2342;
    addr = "127.0.0.1";
    auth.anonymous = {
      enable = true;
      org_role = "Editor";
    };
    analytics.reporting.enable = false;
    provision = {
      enable = true;
      datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://localhost:9001";
          isDefault = true;
        }
      ];
    };
  };

  services.nginx.virtualHosts = {
    "grafana.unixpimps.net" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
        extraConfig = ''
          proxy_set_header X-Forwarded-Proto https;
          proxy_set_header Authorization "";
        '';
        proxyWebsockets = true;
      };
      basicAuth = {
        admin = secrets.grafana.admin;
      };
    };
    "ingress-00.unixpimps.net" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${config.services.prometheus.pushgateway.web.listen-address}";
      };
      basicAuth = {
        ingress-00 = secrets.prometheus-pushgateway.ingress-00;
      };
    };
  };

  services.borgbackup.jobs.services.paths = lib.mkAfter [ "/var/lib/${config.services.prometheus.stateDir}/data/snapshots" ];

  systemd.services.prometheus-dump = {
    description = "prometheus dump";
    after = [ "prometheus.service" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${dumpScript}/bin/prometheus-dump";
    };
  };

  systemd.timers.prometheus-dump = {
    description = "Update timer for prometheus-dump";
    partOf = [ "prometheus-dump.service" ];
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = "02:00:00";
  };
}

{ secrets, config, pkgs, lib, ... }:
let
  dumpScript = pkgs.writeScriptBin "prometheus-dump" ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.coreutils}/bin/sleep 10
    ${pkgs.findutils}/bin/find  /var/lib/${config.services.prometheus.stateDir}/data/snapshots -mindepth 1 -maxdepth 1 -type d -mtime +7 -exec rm -rf {} \;
    ${pkgs.curl}/bin/curl -XPOST http://localhost:9001/api/v1/admin/tsdb/snapshot
  '';
in
{
  services.prometheus = {
    enable = true;
    port = 9001;
    retentionTime = "4320h";
    pushgateway = {
      enable = true;
      web.listen-address = "127.0.0.1:9091";
    };
    extraFlags = [ "--web.enable-admin-api" ];
    globalConfig = {
      scrape_interval = "15s";
    };
    rules = lib.mkBefore [
      ''groups:''
      ''
        - name: prometheus
          rules:
          - alert: PrometheusTargetMissing
            expr: up == 0
            for: 0m
            labels:
              severity: critical
            annotations:
              summary: Prometheus target missing (instance {{ $labels.instance }})
              description: "A Prometheus target has disappeared. An exporter might be crashed.\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
          - alert: PrometheusTooManyRestarts
            expr: changes(process_start_time_seconds{job=~"prometheus|pushgateway|alertmanager"}[15m]) > 2
            for: 0m
            labels:
              severity: warning
            annotations:
              summary: Prometheus too many restarts (instance {{ $labels.instance }})
              description: "Prometheus has restarted more than twice in the last 15 minutes. It might be crashlooping.\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
          - alert: PrometheusNotConnectedToAlertmanager
            expr: prometheus_notifications_alertmanagers_discovered < 1
            for: 0m
            labels:
              severity: critical
            annotations:
              summary: Prometheus not connected to alertmanager (instance {{ $labels.instance }})
              description: "Prometheus cannot connect the alertmanager\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
          - alert: PrometheusNotificationsBacklog
            expr: min_over_time(prometheus_notifications_queue_length[10m]) > 0
            for: 0m
            labels:
              severity: warning
            annotations:
              summary: Prometheus notifications backlog (instance {{ $labels.instance }})
              description: "The Prometheus notification queue has not been empty for 10 minutes\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
          - alert: PrometheusTargetScrapingSlow
            expr: prometheus_target_interval_length_seconds{quantile="0.9"} > 60
            for: 5m
            labels:
              severity: warning
            annotations:
              summary: Prometheus target scraping slow (instance {{ $labels.instance }})
              description: "Prometheus is scraping exporters slowly\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
          - alert: PrometheusTsdbCheckpointCreationFailures
            expr: increase(prometheus_tsdb_checkpoint_creations_failed_total[1m]) > 0
            for: 0m
            labels:
              severity: critical
            annotations:
              summary: Prometheus TSDB checkpoint creation failures (instance {{ $labels.instance }})
              description: "Prometheus encountered {{ $value }} checkpoint creation failures\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
          - alert: PrometheusTsdbCheckpointDeletionFailures
            expr: increase(prometheus_tsdb_checkpoint_deletions_failed_total[1m]) > 0
            for: 0m
            labels:
              severity: critical
            annotations:
              summary: Prometheus TSDB checkpoint deletion failures (instance {{ $labels.instance }})
              description: "Prometheus encountered {{ $value }} checkpoint deletion failures\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
          - alert: PrometheusTsdbCompactionsFailed
            expr: increase(prometheus_tsdb_compactions_failed_total[1m]) > 0
            for: 0m
            labels:
              severity: critical
            annotations:
              summary: Prometheus TSDB compactions failed (instance {{ $labels.instance }})
              description: "Prometheus encountered {{ $value }} TSDB compactions failures\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
          - alert: PrometheusTsdbHeadTruncationsFailed
            expr: increase(prometheus_tsdb_head_truncations_failed_total[1m]) > 0
            for: 0m
            labels:
              severity: critical
            annotations:
              summary: Prometheus TSDB head truncations failed (instance {{ $labels.instance }})
              description: "Prometheus encountered {{ $value }} TSDB head truncation failures\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
          - alert: PrometheusTsdbReloadFailures
            expr: increase(prometheus_tsdb_reloads_failures_total[1m]) > 0
            for: 0m
            labels:
              severity: critical
            annotations:
              summary: Prometheus TSDB reload failures (instance {{ $labels.instance }})
              description: "Prometheus encountered {{ $value }} TSDB reload failures\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
          - alert: PrometheusTsdbWalCorruptions
            expr: increase(prometheus_tsdb_wal_corruptions_total[1m]) > 0
            for: 0m
            labels:
              severity: critical
            annotations:
              summary: Prometheus TSDB WAL corruptions (instance {{ $labels.instance }})
              description: "Prometheus encountered {{ $value }} TSDB WAL corruptions\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
          - alert: PrometheusTsdbWalTruncationsFailed
            expr: increase(prometheus_tsdb_wal_truncations_failed_total[1m]) > 0
            for: 0m
            labels:
              severity: critical
            annotations:
              summary: Prometheus TSDB WAL truncations failed (instance {{ $labels.instance }})
              description: "Prometheus encountered {{ $value }} TSDB WAL truncation failures\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"''
    ];
    scrapeConfigs = [
      {
        job_name = "pushgateway";
        honor_labels = true;
        static_configs = [{
          targets = [ "${config.services.prometheus.pushgateway.web.listen-address}" ];
        }];
      }
    ];
    alertmanagers = [{
      scheme = "http";
      path_prefix = "";
      static_configs = [{
        targets = [
          "127.0.0.1:9093"
        ];
      }];
    }];
    alertmanager = {
      enable = true;
      listenAddress = "127.0.0.1";
      webExternalUrl = "https://alertmanager.unixpimps.net";
      configuration = {
        "global" = {
          "smtp_smarthost" = "delirium.unixpimps.net:587";
          "smtp_from" = "alertmanager@unixpimps.net";
          "smtp_auth_username" = "alertmanager@unixpimps.net";
          "smtp_auth_password" = "${secrets.prometheus.alertmanager.smtpPass}";
          "smtp_require_tls" = true;
        };
        "route" = {
          "group_by" = [ "alertname" "alias" ];
          "group_wait" = "30s";
          "group_interval" = "2m";
          "repeat_interval" = "4h";
          "receiver" = "sysops";
        };
        "receivers" = [
          {
            "name" = "sysops";
            "email_configs" = [
              {
                "to" = "sysops@unixpimps.net";
                "send_resolved" = true;
              }
            ];
          }
        ];
      };
    };
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
    "alertmanager.unixpimps.net" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.prometheus.alertmanager.port}";
      };
      basicAuth = {
        admin = secrets.alertmanager.admin;
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

  services.borgbackup.jobs.services.paths = lib.mkAfter [
    "/var/lib/${config.services.prometheus.stateDir}/data/snapshots"
    "${config.services.grafana.database.path}"
  ];

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

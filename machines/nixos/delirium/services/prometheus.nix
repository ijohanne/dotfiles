{ secrets, config, pkgs, lib, ... }:
{
  services.prometheus = {
    enable = true;
    port = 9001;
    pushgateway = {
      enable = true;
      web.listen-address = "127.0.0.1:9091";
    };
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
}

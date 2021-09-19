{ pkgs, secrets, config, ... }:
{

  services.prometheus = {
    enable = true;
    port = 9001;
    retentionTime = "4320h";
    extraFlags = [ "--web.enable-admin-api" ];
    globalConfig = {
      scrape_interval = "15s";
    };
  };

  services.grafana = {
    enable = true;
    domain = "grafana.est.unixpimps.net";
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
    declarativePlugins = with pkgs.grafanaPlugins; [ grafana-piechart-panel ];
  };

  services.nginx.virtualHosts = {
    "grafana.est.unixpimps.net" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
        extraConfig = ''
          satisfy any;
          allow 10.0.0.0/8;
          deny all;
          proxy_set_header X-Forwarded-Proto https;
          proxy_set_header Authorization "";
        '';
        proxyWebsockets = true;
      };
      basicAuth = {
        admin = secrets.grafana.admin;
      };
    };
  };
}

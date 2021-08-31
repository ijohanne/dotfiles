{ pkgs, config, secrets }:
let
  nginxLuaPrometheus = pkgs.fetchFromGitHub {
    owner = "knyar";
    repo = "nginx-lua-prometheus";
    rev = "f0b277ac92129b19d20cda587a8aab911fdca642";
    sha256 = "09fcmlka1ld1vr19cdaa669bvsiw1v8wh7lsyzp7145hsrn3nz8v";
  };
in
{
  services.prometheus.scrapeConfigs = [
    {
      job_name = "nginx";
      honor_labels = true;
      scheme = "https";
      metrics_path = "/nginx-metrics";
      static_configs = [{
        targets = [ "unixpimps.net" ];
      }];
    }
  ];

  services.nginx = {
    additionalModules = [ pkgs.nginxModules.lua ];
    commonHttpConfig = ''
      lua_shared_dict prometheus_metrics 10M;
      lua_package_path "${nginxLuaPrometheus}/?.lua;;";

      init_worker_by_lua_block {
        prometheus = require("prometheus").init("prometheus_metrics")

        metric_requests = prometheus:counter(
          "nginx_http_requests_total", "Number of HTTP requests", {"host", "status"})
        metric_latency = prometheus:histogram(
          "nginx_http_request_duration_seconds", "HTTP request latency", {"host"})
        metric_connections = prometheus:gauge(
          "nginx_http_connections", "Number of HTTP connections", {"state"})
      }

      log_by_lua_block {
        metric_requests:inc(1, {ngx.var.server_name, ngx.var.status})
        metric_latency:observe(tonumber(ngx.var.request_time), {ngx.var.server_name})
      }
    '';
    virtualHosts."unixpimps.net" = {
      locations."/nginx-metrics" = {
        extraConfig = ''
          allow 141.94.130.22/32;
          allow 2001:41d0:306:116::1/128;
          deny all;
          content_by_lua_block {
            metric_connections:set(ngx.var.connections_reading, {"reading"})
            metric_connections:set(ngx.var.connections_waiting, {"waiting"})
            metric_connections:set(ngx.var.connections_writing, {"writing"})
            prometheus:collect()
          }
        '';
      };
    };
  };
}

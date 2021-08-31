{ pkgs, config, secrets }:
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
  ];
}

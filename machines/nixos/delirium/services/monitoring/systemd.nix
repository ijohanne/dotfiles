{ pkgs, config, secrets }:
{
  services.prometheus.exporters.systemd.enable = true;
  services.prometheus.scrapeConfigs = [
    {
      job_name = "systemd";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.systemd.port}" ];
      }];
    }
  ];
}

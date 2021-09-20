{ config, ... }:
{
  services.prometheus.exporters.unbound = {
    enable = true;
    fetchType = "tcp";
    controlInterface = "127.0.0.1:8953";
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "unbound";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.unbound.port}" ];
      }];
    }
  ];
}

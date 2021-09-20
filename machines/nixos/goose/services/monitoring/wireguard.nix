{ config, ... }:
{
  services.prometheus.exporters.wireguard = {
    enable = true;
    withRemoteIp = true;
  };
  services.prometheus.scrapeConfigs = [
    {
      job_name = "wireguard";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.wireguard.port}" ];
      }];
    }
  ];
}

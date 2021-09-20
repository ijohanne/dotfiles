{ config, ... }:
{
  services.prometheus.exporters.smokeping = {
    enable = true;
    hosts = [
      "8.8.8.8"
      "delirium.unixpimps.net"
      "1.1.1.1"
      "google.com"
    ];
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "smokeping";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.smokeping.port}" ];
      }];
    }
  ];
}

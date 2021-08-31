{ pkgs, config, secrets }:
{
  services.prometheus.exporters.smokeping = {
    enable = true;
    hosts = [
      "google.com"
      "8.8.8.8"
      "141.94.130.254"
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

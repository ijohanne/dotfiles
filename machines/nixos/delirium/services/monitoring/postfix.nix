{ pkgs, config, secrets }:
{
  services.prometheus.exporters.postfix.enable = true;
  services.prometheus.scrapeConfigs = [
    {
      job_name = "postfix";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.postfix.port}" ];
      }];
    }
  ];
}

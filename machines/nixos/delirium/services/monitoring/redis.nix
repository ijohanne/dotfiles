{ pkgs, config, secrets }:
{
  services.prometheus.exporters.redis.enable = true;
  services.prometheus.scrapeConfigs = [
    {
      job_name = "redis";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.redis.port}" ];
      }];
    }
  ];
}

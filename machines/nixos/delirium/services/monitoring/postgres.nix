{ pkgs, config, secrets }:
{
  services.prometheus.exporters.postgres = {
    enable = true;
    runAsLocalSuperUser = true;
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "postgres";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.postgres.port}" ];
      }];
    }
  ];
}

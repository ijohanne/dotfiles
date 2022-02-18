{ ... }:
{
  services.prometheus.scrapeConfigs = [
    {
      job_name = "zfs";
      honor_labels = true;
      static_configs = [{
        targets = [ "10.255.101.243:9134" ];
      }];
    }
  ];
}

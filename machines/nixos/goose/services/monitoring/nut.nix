{ ... }:
{
  services.prometheus.scrapeConfigs = [
    {
      job_name = "nut";
      honor_labels = true;
      params.target = [ "127.0.0.1:3493" ];
      static_configs = [{
        targets = [ "10.255.101.243:9995" "10.255.100.202:9995" ];
      }];
    }
  ];
}

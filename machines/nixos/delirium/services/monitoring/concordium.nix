{
  services.prometheus = {
    scrapeConfigs = [
      {
        job_name = "concordium";
        honor_labels = true;
        static_configs = [{
          targets = [ "127.0.0.1:9982" ];
        }];
      }
    ];
  };
}

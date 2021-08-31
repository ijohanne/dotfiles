{ pkgs, config, secrets }:
{
  services.matrix-synapse = {
    enable_metrics = true;
    listeners = [
      {
        bind_address = "127.0.0.1";
        port = 9092;
        tls = false;
        resources = [{ names = [ "metrics" ]; compress = false; }];
      }
    ];
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "synapse";
      honor_labels = true;
      metrics_path = "/_synapse/metrics";
      static_configs = [{
        targets = [ "127.0.0.1:9092" ];
      }];
    }
  ];
}

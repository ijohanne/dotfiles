{ secrets, ... }:
{
  services.telegraf = {
    enable = true;
    extraConfig = {
      outputs.prometheus_client = {
        metric_version = 2;
        listen = ":9273";
        collectors_exclude = [ "gocollector" "process" ];
        export_timestamp = false;
      };
      inputs.fireboard.auth_token = secrets.fireboard.token;
    };
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "telegraf";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:9273" ];
      }];
    }
  ];
}

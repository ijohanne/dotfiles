{ pkgs, config, secrets }:
{
  services.gitea = {
    settings = {
      metrics = {
        ENABLED = true;
      };
    };
  };
  services.prometheus.scrapeConfigs = [
    {
      job_name = "gitea";
      honor_labels = true;
      scheme = "https";
      static_configs = [{
        targets = [ "git.unixpimps.net" ];
      }];
    }
  ];
}

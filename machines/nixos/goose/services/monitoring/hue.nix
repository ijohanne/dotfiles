{ pkgs, secrets, ... }:
let
  hueExporterSrc = pkgs.fetchFromGitHub {
    owner = "ijohanne";
    repo = "hue_exporter";
    rev = "1babbed94ad61975ee488bd4cbbd15a61cc4ae45";
    sha256 = "0783ig6hfdhwpbgs064q72g11kp20mkv97wfydl8w2s552wkxz3s";
  };
  hueExporter = pkgs.buildGoModule rec {
    name = "hue-exporter";
    src = hueExporterSrc;
    vendorSha256 = "1k67fxaf831pydjfbmhawdm4kpyallqjg5mprf57hfwr8cqrba2g";
    checkFlags = [ "-short" ];
  };
in
{
  users.users."hue-exporter" = {
    description = "Prometheus Philips Hue exporter service user";
    isSystemUser = true;
    group = "hue-exporter";
  };
  users.groups."hue-exporter" = { };

  systemd.services."prometheus-hue-exporter" = {
    environment = { };
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.PrivateTmp = true;
    serviceConfig.WorkingDirectory = /tmp;
    serviceConfig.DynamicUser = false;
    serviceConfig.User = "hue-exporter";
    serviceConfig.Group = "hue-exporter";
    serviceConfig.ExecStart = ''
      ${hueExporter}/bin/hue_exporter \
        -hue-url 10.255.101.240 \
        -username ${secrets.hueApiKey} \
        -metrics-file ${hueExporterSrc}/hue_metrics.json
    '';
  };
  services.prometheus.scrapeConfigs = [
    {
      job_name = "hue";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:9773" ];
      }];
    }
  ];
}

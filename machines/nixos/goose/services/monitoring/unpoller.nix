{ pkgs, secrets, ... }:
let
  unpoller = pkgs.buildGoModule rec {
    name = "unpoller";
    src = pkgs.fetchFromGitHub {
      owner = "unpoller";
      repo = "unpoller";
      rev = "938e8d19aea3a8ff045517f9618c3e966ef18b93";
      sha256 = "1w29636s8wczvrl42pzwr9h1lwkkamka95a3xflmp42crd03nmr8";
    };
    vendorSha256 = "1m0x9w2h8fs6sv4icm4naymby0jrkjjklg4bw7r7p6418lva3z6c";
    checkFlags = [ "-short" ];
  };
  unpollerConfig = pkgs.writeText "unpoller.com" ''
    [unifi.defaults]
      url = "https://10.255.254.240:8443"
      user = "${secrets.cloudkey.username}"
      pass = "${secrets.cloudkey.password}"
      save_sites = true
      save_ids = false
      save_events = false
      save_alarms = false
      save_dpi = false
      save_rogue = true
      verify_ssl = false
      sites = [ "default" ]
    [influxdb]
      disable = true
  '';
in
{
  users.users."unpoller-exporter" = {
    description = "Prometheus Unpoller exporter service user";
    isSystemUser = true;
    group = "unpoller-exporter";
  };
  users.groups."unpoller-exporter" = { };

  systemd.services."prometheus-unpoller-exporter" = {
    environment = { };
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.PrivateTmp = true;
    serviceConfig.WorkingDirectory = /tmp;
    serviceConfig.DynamicUser = false;
    serviceConfig.User = "unpoller-exporter";
    serviceConfig.Group = "unpoller-exporter";
    serviceConfig.ExecStart = ''
      ${unpoller}/bin/unpoller \
      --config=${unpollerConfig}
    '';
  };
  services.prometheus.scrapeConfigs = [
    {
      job_name = "unifipoller";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:9130" ];
      }];
    }
  ];
}

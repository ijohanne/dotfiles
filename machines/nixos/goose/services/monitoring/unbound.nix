{ pkgs, ... }:
let
  unbound = pkgs.rustPlatform.buildRustPackage rec {
    name = "unbound-telemetry";
    src = pkgs.fetchFromGitHub {
      owner = "svartalf";
      repo = "unbound-telemetry";
      rev = "19e53b05828a43b7062b67a9cc6c84836ca26439";
      sha256 = "1bjiyxqm0hhrjv3alrrzg1qv9w7f09rwyyzx9b7zy955l57zsjn2";
    };
    buildInputs = with pkgs; [ openssl openssl.dev ];
    nativeBuildInputs = with pkgs; [ pkg-config ];
    cargoSha256 = "1mpijz3s4cyv38h6pg4384rgykdhxs023b9m5li5fz8s1a56jk9n";
  };
in
{
  users.users."unbound-exporter" = {
    description = "Prometheus Unbound exporter service user";
    isSystemUser = true;
    group = "unbound-exporter";
  };
  users.groups."unbound-exporter" = { };

  systemd.services."prometheus-unbound-exporter" = {
    environment = { };
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    requires = [ "unbound.service" ];
    serviceConfig.Restart = "always";
    serviceConfig.PrivateTmp = true;
    serviceConfig.WorkingDirectory = /tmp;
    serviceConfig.DynamicUser = false;
    serviceConfig.User = "unbound-exporter";
    serviceConfig.Group = "unbound-exporter";
    serviceConfig.ExecStart = "${unbound}/bin/unbound-telemetry tcp";
  };
  services.prometheus.scrapeConfigs = [
    {
      job_name = "unbound";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:9167" ];
      }];
    }
  ];
}

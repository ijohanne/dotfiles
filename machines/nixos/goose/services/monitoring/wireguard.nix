{ pkgs, ... }:
let
  wireguard = pkgs.rustPlatform.buildRustPackage rec {
    name = "prometheus-wireguard-exporter";
    src = pkgs.fetchFromGitHub {
      owner = "MindFlavor";
      repo = "prometheus_wireguard_exporter";
      rev = "62fe64e1c0c3f8e8d2298d3164227b767dd6f69c";
      sha256 = "04d5ckccpfz6kzbfjpn1xlxwkrvl4g2wmwkhb854w37f9z2v3xva";
    };
    cargoSha256 = "0qlclwz8z9kwx6gsswa5aricik5ai1fc2g7ndil69dwlr8vb67c6";
  };
  wireguardConf = pkgs.writeText "wireguard.conf" ''
  '';
  startScript = pkgs.writeScriptBin "startScript" ''
    #!${pkgs.stdenv.shell}
    PATH="$PATH:${pkgs.wireguard}/bin" ${wireguard}/bin/prometheus_wireguard_exporter -n ${wireguardConf} -i wg0
  '';
in
{
  users.users."wireguard-exporter" = {
    description = "Prometheus Wireguard exporter service user";
    isSystemUser = true;
    group = "wireguard-exporter";
  };
  users.groups."wireguard-exporter" = { };

  systemd.services."prometheus-wireguard-exporter" = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    requires = [ "wireguard-wg0.service" ];
    serviceConfig.Restart = "always";
    serviceConfig.PrivateTmp = true;
    serviceConfig.WorkingDirectory = /tmp;
    serviceConfig.DynamicUser = false;
    serviceConfig.User = "wireguard-exporter";
    serviceConfig.Group = "wireguard-exporter";
    serviceConfig.AmbientCapabilities = [ "CAP_NET_ADMIN" ];
    serviceConfig.ExecStart = "${startScript}/bin/startScript";
  };
  services.prometheus.scrapeConfigs = [
    {
      job_name = "wireguard";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:9586" ];
      }];
    }
  ];
}

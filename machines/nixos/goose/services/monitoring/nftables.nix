{ pkgs, ... }:
let
  nftables = pkgs.buildGoModule rec {
    name = "nftables-exporter";
    src = pkgs.fetchFromGitHub {
      owner = "Intrinsec";
      repo = "nftables_exporter";
      rev = "3fc66b606fa60b35bc36d9fc27855e5f50beea8d";
      sha256 = "0258qhv49m32sncs4mxxsf58rprxnr08xj6c2k1sfqq44l8m27ns";
    };
    vendorSha256 = null;
    checkFlags = [ "-short" ];
  };
in
{
  users.users."nftables-exporter" = {
    description = "Prometheus nftables exporter service user";
    isSystemUser = true;
    group = "nftables-exporter";
  };
  users.groups."nftables-exporter" = { };

  systemd.services."prometheus-nftables-exporter" = {
    environment = { };
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.PrivateTmp = true;
    serviceConfig.WorkingDirectory = /tmp;
    serviceConfig.DynamicUser = false;
    serviceConfig.User = "nftables-exporter";
    serviceConfig.Group = "nftables-exporter";
    serviceConfig.AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_SYS_ADMIN" ];
    serviceConfig.ExecStart = ''
      ${nftables}/bin/nftables_exporter
    '';
  };
  services.prometheus.scrapeConfigs = [
    {
      job_name = "nftables";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:9732" ];
      }];
    }
  ];
}

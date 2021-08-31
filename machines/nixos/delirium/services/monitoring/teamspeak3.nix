{ pkgs, config, secrets }:
let
  ts3exporter = pkgs.buildGoModule rec {
    name = "ts3exporter";

    src = pkgs.fetchFromGitHub {
      owner = "ijohanne";
      repo = "ts3exporter";
      rev = "e8d0a46ea0e73cfc7924685006a19a2b872673e3";
      sha256 = "187sxyiglm728s113cb0kh8jldibwaw7mk6h2f97jpl2s9svccbi";
    };
    vendorSha256 = "15jzxm4yviv1pjhb9zjmy0zccn28qcdwsk1pkx3x8yl0h2hdxpgf";
    # skips tests with external dependencies, e.g. on mysqld
    checkFlags = [ "-short" ];
  };
in
{
  users.users."teamspeak3-exporter" = {
    description = "Prometheus TeamSpeak3 exporter service user";
    isSystemUser = true;
    group = "teamspeak3-exporter";
  };
  users.groups."teamspeak3-exporter" = { };
  systemd.services."prometheus-teamspeak3-exporter" = {
    environment = {
      SERVERQUERY_PASSWORD = secrets.teamspeak3.serveradmin;
    };
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.PrivateTmp = true;
    serviceConfig.WorkingDirectory = /tmp;
    serviceConfig.DynamicUser = false;
    serviceConfig.User = "teamspeak3-exporter";
    serviceConfig.Group = "teamspeak3-exporter";
    serviceConfig.ExecStart = ''
      ${ts3exporter}/bin/ts3exporter \
        -enablechannelmetrics \
        -ignorefloodlimits \
        -listen 127.0.0.1:9189 \
        -remote 127.0.0.1:10011 \
        -user serveradmin
    '';
  };
  services.prometheus.scrapeConfigs = [
    {
      job_name = "teamspeak3";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:9189" ];
      }];
    }
  ];
}

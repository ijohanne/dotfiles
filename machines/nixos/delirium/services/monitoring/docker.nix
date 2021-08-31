{ pkgs, config, secrets }:
{
  systemd.services.prometheus-docker-exporter = {
    enable = config.services.prometheus.enable;
    description = "Docker exporter for Prometheus";
    after = [ "docker.service" ];
    bindsTo = [ "docker.service" ];
    wantedBy = [ "prometheus.service" ];
    serviceConfig = {
      Restart = "always";
      ExecStartPre = [
        "-${pkgs.docker}/bin/docker stop prometheus_docker_exporter"
        "-${pkgs.docker}/bin/docker rm prometheus_docker_exporter"
        "${pkgs.docker}/bin/docker pull prometheusnet/docker_exporter"
      ];
      ExecStart = "${pkgs.docker}/bin/docker run --rm --name prometheus_docker_exporter --volume \"/var/run/docker.sock\":\"/var/run/docker.sock\" --publish 9417:9417 prometheusnet/docker_exporter";
    };
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "docker";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:9417" ];
      }];
    }
  ];
}

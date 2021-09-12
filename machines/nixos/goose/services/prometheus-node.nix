{ config, ... }:
{
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "cpu"
      "schedstat"
      "sockstat"
      "softnet"
      "rapl"
      "powersupplyclass"
      "netclass"
      "hwmon"
      "cpufreq"
      "bcache"
      "timex"
      "thermal_zone"
      "conntrack"
      "diskstats"
      "entropy"
      "filefd"
      "filesystem"
      "loadavg"
      "mdadm"
      "meminfo"
      "netdev"
      "netstat"
      "stat"
      "time"
      "vmstat"
      "systemd"
      "logind"
      "interrupts"
      "ksmd"
    ];
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "node";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
      }];
    }
  ];
}

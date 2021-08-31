{ pkgs, config, secrets }:
{
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
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

  services.prometheus.rules = [
    ''
      - name: node
        rules:
          - alert: HostSystemdServiceCrashed
            expr: node_systemd_unit_state{state="failed"} == 1
            for: 0m
            labels:
              severity: warning
            annotations:
              summary: Host systemd service crashed (instance {{ $labels.instance }})
              description: "systemd service crashed\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
          - alert: HostRaidDiskFailure
            expr: node_md_disks{state="failed"} > 0
            for: 2m
            labels:
              severity: warning
            annotations:
              summary: Host RAID disk failure (instance {{ $labels.instance }})
              description: "At least one device in RAID array on {{ $labels.instance }} failed. Array {{ $labels.md_device }} needs attention and possibly a disk swap\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"''
  ];

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

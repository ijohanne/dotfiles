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

  services.prometheus = {
    rules = [
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
                description: "At least one device in RAID array on {{ $labels.instance }} failed. Array {{ $labels.md_device }} needs attention and possibly a disk swap\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: HostOutOfMemory
              expr: node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100 < 10
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Host out of memory (instance {{ $labels.instance }})
                description: "Node memory is filling up (< 10% left)\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: HostMemoryUnderMemoryPressure
              expr: rate(node_vmstat_pgmajfault[1m]) > 1000
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Host memory under memory pressure (instance {{ $labels.instance }})
                description: "The node is under heavy memory pressure. High rate of major page faults\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: HostUnusualDiskReadLatency
              expr: rate(node_disk_read_time_seconds_total[1m]) / rate(node_disk_reads_completed_total[1m]) > 0.1 and rate(node_disk_reads_completed_total[1m]) > 0
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Host unusual disk read latency (instance {{ $labels.instance }})
                description: "Disk latency is growing (read operations > 100ms)\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: HostUnusualDiskWriteLatency
              expr: rate(node_disk_write_time_seconds_total[1m]) / rate(node_disk_writes_completed_total[1m]) > 0.1 and rate(node_disk_writes_completed_total[1m]) > 0
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Host unusual disk write latency (instance {{ $labels.instance }})
                description: "Disk latency is growing (write operations > 100ms)\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: HostOomKillDetected
              expr: increase(node_vmstat_oom_kill[1m]) > 0
              for: 0m
              labels:
                severity: warning
              annotations:
                summary: Host OOM kill detected (instance {{ $labels.instance }})
                description: "OOM kill detected\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: HostEdacCorrectableErrorsDetected
              expr: increase(node_edac_correctable_errors_total[1m]) > 0
              for: 0m
              labels:
                severity: info
              annotations:
                summary: Host EDAC Correctable Errors detected (instance {{ $labels.instance }})
                description: "Host {{ $labels.instance }} has had {{ printf \"%.0f\" $value }} correctable memory errors reported by EDAC in the last 5 minutes.\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: HostEdacUncorrectableErrorsDetected
              expr: node_edac_uncorrectable_errors_total > 0
              for: 0m
              labels:
                severity: warning
              annotations:
                summary: Host EDAC Uncorrectable Errors detected (instance {{ $labels.instance }})
                description: "Host {{ $labels.instance }} has had {{ printf \"%.0f\" $value }} uncorrectable memory errors reported by EDAC in the last 5 minutes.\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: HostNetworkReceiveErrors
              expr: rate(node_network_receive_errs_total[2m]) / rate(node_network_receive_packets_total[2m]) > 0.01
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Host Network Receive Errors (instance {{ $labels.instance }})
                description: "Host {{ $labels.instance }} interface {{ $labels.device }} has encountered {{ printf \"%.0f\" $value }} receive errors in the last five minutes.\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: HostNetworkTransmitErrors
              expr: rate(node_network_transmit_errs_total[2m]) / rate(node_network_transmit_packets_total[2m]) > 0.01
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Host Network Transmit Errors (instance {{ $labels.instance }})
                description: "Host {{ $labels.instance }} interface {{ $labels.device }} has encountered {{ printf \"%.0f\" $value }} transmit errors in the last five minutes.\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: HostNetworkInterfaceSaturated
              expr: (rate(node_network_receive_bytes_total{device!~"^tap.*"}[1m]) + rate(node_network_transmit_bytes_total{device!~"^tap.*"}[1m])) / node_network_speed_bytes{device!~"^tap.*"} > 0.8 < 10000
              for: 1m
              labels:
                severity: warning
              annotations:
                summary: Host Network Interface Saturated (instance {{ $labels.instance }})
                description: "The network interface \"{{ $labels.device }}\" on \"{{ $labels.instance }}\" is getting overloaded.\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: HostConntrackLimit
              expr: node_nf_conntrack_entries / node_nf_conntrack_entries_limit > 0.8
              for: 5m
              labels:
                severity: warning
              annotations:
                summary: Host conntrack limit (instance {{ $labels.instance }})
                description: "The number of conntrack is approching limit\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: HostClockSkew
              expr: (node_timex_offset_seconds > 0.05 and deriv(node_timex_offset_seconds[5m]) >= 0) or (node_timex_offset_seconds < -0.05 and deriv(node_timex_offset_seconds[5m]) <= 0)
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Host clock skew (instance {{ $labels.instance }})
                description: "Clock skew detected. Clock is out of sync.\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"''
    ];
    scrapeConfigs = [
      {
        job_name = "node";
        honor_labels = true;
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
    ];
  };
}

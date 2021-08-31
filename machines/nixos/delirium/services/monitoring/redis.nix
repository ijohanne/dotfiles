{ pkgs, config, secrets }:
{
  services.prometheus.exporters.redis.enable = true;
  services.prometheus = {
    rules = [
      ''
        - name: redis
          rules:
            - alert: RedisDown
              expr: redis_up == 0
              for: 0m
              labels:
                severity: critical
              annotations:
                summary: Redis down (instance {{ $labels.instance }})
                description: "Redis instance is down\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: RedisTooManyConnections
              expr: redis_connected_clients > 100
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Redis too many connections (instance {{ $labels.instance }})
                description: "Redis instance has too many connections\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"''
    ];
    scrapeConfigs = [
      {
        job_name = "redis";
        honor_labels = true;
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.redis.port}" ];
        }];
      }
    ];
  };
}

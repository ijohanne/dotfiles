{ pkgs, config, secrets }:
{
  services.prometheus.exporters.postgres = {
    enable = true;
    runAsLocalSuperUser = true;
  };

  services.prometheus = {
    rules = [
      ''
        - name: postgres
          rules:
            - alert: PostgresqlDown
              expr: pg_up == 0
              for: 0m
              labels:
                severity: critical
              annotations:
                summary: Postgresql down (instance {{ $labels.instance }})
                description: "Postgresql instance is down\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: PostgresqlExporterError
              expr: pg_exporter_last_scrape_error > 0
              for: 0m
              labels:
                severity: critical
              annotations:
                summary: Postgresql exporter error (instance {{ $labels.instance }})
                description: "Postgresql exporter is showing errors. A query may be buggy in query.yaml\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: PostgresqlTooManyConnections
              expr: sum by (datname) (pg_stat_activity_count{datname!~"template.*|postgres"}) > pg_settings_max_connections * 0.8
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Postgresql too many connections (instance {{ $labels.instance }})
                description: "PostgreSQL instance has too many connections (> 80%).\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: PostgresqlDeadLocks
              expr: increase(pg_stat_database_deadlocks{datname!~"template.*|postgres"}[1m]) > 5
              for: 0m
              labels:
                severity: warning
              annotations:
                summary: Postgresql dead locks (instance {{ $labels.instance }})
                description: "PostgreSQL has dead-locks\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: PostgresqlSlowQueries
              expr: pg_slow_queries > 0
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Postgresql slow queries (instance {{ $labels.instance }})
                description: "PostgreSQL executes slow queries\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: PostgresqlHighRollbackRate
              expr: rate(pg_stat_database_xact_rollback{datname!~"template.*"}[3m]) / rate(pg_stat_database_xact_commit{datname!~"template.*"}[3m]) > 0.02
              for: 0m
              labels:
                severity: warning
              annotations:
                summary: Postgresql high rollback rate (instance {{ $labels.instance }})
                description: "Ratio of transactions being aborted compared to committed is > 2 %\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"''
    ];
    scrapeConfigs = [
      {
        job_name = "postgres";
        honor_labels = true;
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.postgres.port}" ];
        }];
      }
    ];
  };
}

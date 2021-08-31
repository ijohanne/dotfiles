{ pkgs, config, secrets }:
{
  services.dovecot2 = {
    mailPlugins.globally.enable = [ "old_stats" ];
    extraConfig = ''
      service old-stats {
        unix_listener old-stats {
          user = ${config.services.dovecot2.user}
          group = ${config.services.dovecot2.group}
          mode = 0660
        }
        fifo_listener old-stats-mail {
          mode = 0660
          user = ${config.services.dovecot2.user}
          group = ${config.services.dovecot2.group}
        }
        fifo_listener old-stats-user {
          mode = 0660
          user = ${config.services.dovecot2.user}
          group = ${config.services.dovecot2.group}
        }
      }
      plugin {
        old_stats_refresh = 30 secs
        old_stats_track_cmds = yes
      }
    '';
  };

  services.prometheus.exporters.dovecot = {
    user = config.services.dovecot2.user;
    group = config.services.dovecot2.group;
    enable = true;
    scopes = [ "user" "global" ];
    socketPath = "/var/run/dovecot2/old-stats";
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "dovecot";
      honor_labels = true;
      static_configs = [{
        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.dovecot.port}" ];
      }];
    }
  ];
}

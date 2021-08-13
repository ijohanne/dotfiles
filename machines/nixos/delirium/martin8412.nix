{ secrets, config, pkgs, lib, ... }:

{
  containers = {
    martin8412 = {
      privateNetwork = false;
      autoStart = true;
      ephemeral = false;
      bindMounts =
        {
          "/var/data/torrent" = {
            hostPath = "/var/data/torrent/martin8412";
            isReadOnly = false;
          };
        };
      config = { config, pkgs, ... }: {
        services.deluge = {
          enable = true;
          package = pkgs.deluge-1_x;
          web = {
            enable = true;
            port = 8112;
          };
          declarative = true;
          config = {
            allow_remote = true;
            download_location = "/var/data/torrent/Downloads";
            move_completed_path = "/var/data/torrent/Downloads";
            torrentfiles_location = "/var/data/torrent/Downloads";
            daemon_port = 58846;
            random_port = false;
            listen_ports = [ 34200 34210 ];
            dht = false;
            enc_level = 2;
            enc_in_policy = 1;
            enc_out_policy = 1;
            lsd = false;
            natpmp = false;
            upnp = false;
            utpex = false;
            enabled_plugins = [ "Label" "Stats" ];
          };
          authFile = pkgs.writeText "deluge-auth" ''
            localclient:${secrets.torrents.martin8412}:10
          '';
        };
        services.plex = {
          enable = true;
          dataDir = "/var/data/torrent/Downloads";
          group = "deluge";
          user = "deluge";
        };
        nixpkgs.config.allowUnfree = true;
      };
    };
  };

  services.nginx = {
    virtualHosts = {
      "transmission.unixpimps.net" = {
        http2 = true;
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:8112";
            extraConfig = ''
              proxy_set_header X-Deluge-Base "/";
              add_header X-Frame-Options SAMEORIGIN;
            '';
          };
        };
        basicAuth = {
          martin8412 = secrets.torrents.martin8412;
        };
      };
    };
  };

  networking.firewall =
    {
      allowedTCPPorts = [
        # Plex Martin8412
        32400
        32469
        3005
        8324
        # Deluge Martin8412
        34200
        34210
      ];
      allowedUDPPorts = [
        # Deluge Martin8412
        34200
        34210
        # Plex Martin8412
        1900
        5353
        32410
        32412
        32413
        32414
      ];
    };
}

{ secrets, config, pkgs, lib, ... }:

{
  containers = {
    izabella = {
      privateNetwork = false;
      autoStart = true;
      ephemeral = false;
      bindMounts =
        {
          "/var/data/torrent" = {
            hostPath = "/var/data/torrent/izabella";
            isReadOnly = false;
          };
        };
      config = { config, pkgs, ... }: {
        services.deluge = {
          enable = true;
          package = pkgs.deluge-1_x;
          web = {
            enable = true;
            port = 8113;
          };
          declarative = true;
          config = {
            allow_remote = true;
            download_location = "/var/data/torrent/Downloads";
            move_completed_path = "/var/data/torrent/Downloads";
            torrentfiles_location = "/var/data/torrent/Downloads";
            daemon_port = 58847;
            random_port = false;
            listen_ports = [ 35200 35210 ];
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
            localclient:${secrets.torrents.izabella}:10
          '';
        };
        nixpkgs.config.allowUnfree = true;
      };
    };
  };

  services.nginx = {
    virtualHosts = {
      "izabella.unixpimps.net" = {
        http2 = true;
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:8113";
            extraConfig = ''
              proxy_set_header X-Deluge-Base "/";
              add_header X-Frame-Options SAMEORIGIN;
            '';
          };
        };
        basicAuth = {
          izabella = secrets.torrents.izabella;
        };
      };
    };
  };

  networking.firewall =
    {
      allowedTCPPorts = [
        # Deluge izabella
        35200
        35210
      ];
      allowedUDPPorts = [
        # Deluge izabella
        35200
        35210
      ];
    };
}

{ mkRtorrentInstance, secrets, config, pkgs, lib, ... }:
{
  imports = [
    (mkRtorrentInstance { id = 0; enable = true; datadir = "/var/data/torrent/martin8412"; })
  ];

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
      config = {
        services.plex = {
          enable = true;
          dataDir = "/var/data/torrent/Downloads";
        };
        nixpkgs.config.allowUnfree = true;
      };
    };
  };

  services.nginx = {
    virtualHosts = {
      "transmission.unixpimps.net" = {
        serverAliases = [ "martin8412.unixpimps.net" ];
        http2 = true;
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:42000";
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
      ];
      allowedUDPPorts = [
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

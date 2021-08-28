{ mkRtorrentInstance, secrets, config, pkgs, lib, ... }:
{
  imports = [
    (mkRtorrentInstance { id = 1; enable = true; datadir = "/var/data/torrent/krumme"; })
  ];

  services.nginx = {
    virtualHosts = {
      "krumme.unixpimps.net" = {
        http2 = true;
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:42001";
          };
        };
        basicAuth = {
          krumme = secrets.torrents.krumme;
        };
      };
    };
  };
}

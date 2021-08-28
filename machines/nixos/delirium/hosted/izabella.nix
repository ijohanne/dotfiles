{ mkRtorrentInstance, secrets, config, pkgs, lib, ... }:
{
  imports = [
    (mkRtorrentInstance { id = 2; enable = true; datadir = "/var/data/torrent/izabella"; })
  ];

  services.nginx = {
    virtualHosts = {
      "izabella.unixpimps.net" = {
        http2 = true;
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:42002";
          };
        };
        basicAuth = {
          izabella = secrets.torrents.izabella;
        };
      };
    };
  };
}

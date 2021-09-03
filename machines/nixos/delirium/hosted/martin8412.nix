{ mkRtorrentInstance, secrets, config, pkgs, lib, ... }:
{
  imports = [
    (mkRtorrentInstance {
      id = 0;
      enable = true;
      datadir = "/var/data/torrent/martin8412";
      extraconf = ''
        # upon completion, move content to path specified above via custom1
        method.insert = d.data_path, simple, "if=(d.is_multi_file), (cat,(d.directory),/), (cat,(d.directory),/,(d.name))"
        method.insert = d.move_to_complete, simple, "d.directory.set=$argument.1=; execute=mkdir,-p,$argument.1=; execute=mv,-u,$argument.0=,$argument.1=; d.save_full_session="
        method.set_key = event.download.finished,move_complete,"d.move_to_complete=$d.data_path=,$d.custom1="
      '';
    }
    )
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
      config = { config, pkgs, ... }: {
        services.plex = {
          enable = true;
          package = pkgs.plex;
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
      "data.unixpimps.net" = {
        http2 = true;
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            root = "/var/data/torrent/martin8412";
          };
        };
        basicAuth = {
          martin8412 = secrets.torrents.martin8412;
        };
        extraConfig = ''
          autoindex on;
        '';
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

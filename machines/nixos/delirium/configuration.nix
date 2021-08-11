{ config, pkgs, lib, ... }:

let
  secrets = (import /etc/nixos/secrets.nix);
  pr_119719 = builtins.fetchTarball {
    name = "nixos-pr_119719";
    url = "https://api.github.com/repos/greizgh/nixpkgs/tarball/seafile";
    sha256 = "1xs075sh741ra2479id9q3yms93v3i0j1rfmvxvc563wbxdpfs7r";
  };
in
{
  imports =
    [
      ./hardware-configuration.nix
      (builtins.fetchTarball {
        url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-21.05/nixos-mailserver-nixos-21.05.tar.gz";
        sha256 = "1fwhb7a5v9c98nzhf3dyqf3a5ianqh7k50zizj8v5nmj3blxw4pi";
      })
    ];

  environment.systemPackages = with pkgs; [ ripgrep vim nixpkgs-fmt htop fish git ];

  boot.kernelPackages = pkgs.linuxPackages_5_13;
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    mirroredBoots = [
      { devices = [ "nodev" ]; path = "/boot/ESP0"; }
      { devices = [ "nodev" ]; path = "/boot/ESP1"; }
    ];
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/EFI";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "delirium";
  environment.etc."mdadm.conf".text = ''
    HOMEHOST delirium
  '';
  boot.initrd.mdadmConf = config.environment.etc."mdadm.conf".text;

  networking = {
    useDHCP = false;
    interfaces."eno1" = {
      ipv4.addresses = [
        {
          address = "141.94.130.22";
          prefixLength = 24;
        }
      ];
      ipv6.addresses = [
        {
          address = "2001:41d0:306:116::1";
          prefixLength = 64;
        }
      ];
      ipv6.routes = [
        {
          address = "2001:41d0:306:1ff:ff:ff:ff:ff";
          prefixLength = 128;
          options = {
            dev = "eno1";
          };
        }
      ];
    };
    defaultGateway = "141.94.130.254";
    defaultGateway6 = "2001:41d0:306:1ff:ff:ff:ff:ff";
    nameservers = [ "8.8.8.8" ];
  };

  users.users.root.initialHashedPassword = "";
  services.openssh.permitRootLogin = "prohibit-password";
  services.xserver = { enable = false; };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKeFunHfY3vS2izkp7fMHk2bXuaalNijYcctAF2NGc1T"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKiCGBgFgwbHB+2m++ViEnhoFjww2Twvx8gXWcMvHvz3 martin@martin8412.dk"
  ];
  users.users = {
    mj = {
      createHome = true;
      description = "Martin Karlsen Jensen";
      extraGroups = [
        "wheel"
      ];
      group = "adm";
      isNormalUser = true;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKiCGBgFgwbHB+2m++ViEnhoFjww2Twvx8gXWcMvHvz3 martin@martin8412.dk"
      ];
    };
    ij = {
      createHome = true;
      description = "Ian Johannesen";
      extraGroups = [
        "wheel"
      ];
      group = "adm";
      isNormalUser = true;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKeFunHfY3vS2izkp7fMHk2bXuaalNijYcctAF2NGc1T"
      ];
    };
  };

  nix.maxJobs = lib.mkDefault 64;

  services.openssh.enable = true;

  security.sudo = {
    enable = true;
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

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
            listen_ports = [ 6881 6882 ];
            dht = false;
            enc_level = 2;
            enc_in_policy = 1;
            enc_out_policy = 1;
            lsd = false;
            natpmp = false;
            upnp = false;
            utpex = false;
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
    seafile = {
      privateNetwork = true;
      autoStart = true;
      ephemeral = false;
      nixpkgs = pr_119719;
      hostAddress = "192.168.100.2";
      localAddress = "192.168.100.11";
      bindMounts =
        {
          "/var/lib/seafile" = {
            hostPath = "/var/data/seafile";
            isReadOnly = false;
          };
        };
      config = { config, pkgs, ... }: {
        services.kresd.enable = true;
        services.seafile = {
          enable = true;
          ccnetSettings.General.SERVICE_URL = "https://seafile.unixpimps.net";
          seahubExtraConf = ''
            CSRF_TRUSTED_ORIGINS = ['seafile.unixpimps.net']
          '';
          adminEmail = "sysops@unixpimps.net";
          initialAdminPassword = secrets.seafile.admin;
        };
        networking.firewall.allowedTCPPorts = [ 80 ];
        services.nginx = {
          enable = true;
          virtualHosts."seafile.unixpimps.net" = {
            locations."/" = {
              proxyPass = "http://unix:/run/seahub/gunicorn.sock";
              extraConfig = ''
                proxy_set_header X-Forwarded-Proto https;
              '';
            };
            locations."/seafhttp" = {
              proxyPass = "http://127.0.0.1:8082";
              extraConfig = ''
                rewrite ^/seafhttp(.*)$ $1 break;
                client_max_body_size 0;
                proxy_connect_timeout  36000s;
                proxy_set_header X-Forwarded-Proto https;
                proxy_set_header Host $host:$server_port;
                proxy_read_timeout  36000s;
                proxy_send_timeout  36000s;
                send_timeout  36000s;
                proxy_http_version 1.1;
              '';
            };
          };
        };
      };
    };
  };

  networking.nat.enable = true;
  networking.nat.internalInterfaces = [ "ve-seafile" ];
  networking.nat.externalInterface = "eno1";

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
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
      "seafile.unixpimps.net" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://192.168.100.11";
            extraConfig = ''
              client_max_body_size 0;
              proxy_read_timeout 310s;
            '';
          };
        };
      };
    };
  };

  security.acme = {
    email = "mkj@opsplaza.com";
    acceptTerms = true;
  };

  services.roundcube = {
    enable = true;
    hostName = "webby.unixpimps.net";
    extraConfig = ''
      $config['smtp_server'] = 'tls://delirium.unixpimps.net';
    '';
  };

  mailserver = {
    enable = true;
    fqdn = "delirium.unixpimps.net";
    domains = [ "shouldidrink.today" ];
    virusScanning = true;
    loginAccounts = {
      "ij@shouldidrink.today" = {
        hashedPassword = secrets.mail.ij;
        aliases = [
        ];
      };
    };
    certificateScheme = 3;
  };

  networking.firewall =
    {
      allowedTCPPorts = [
        # Web ports
        80
        443
        # SSH
        22
        # Plex Martin8412
        32400
        32469
        3005
        8324
        # Deluge Martin8412
        6881
        6882
      ];
      allowedUDPPorts = [
        # Deluge Martin8412
        6881
        6882
        # Plex Martin8412
        1900
        5353
        32410
        32412
        32413
        32414
      ];
    };

  virtualisation.docker.enable = true;

  system.stateVersion = "21.05";
}

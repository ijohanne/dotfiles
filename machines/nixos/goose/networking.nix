{ ... }:

{
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.all.autoconf" = 1;
    "net.ipv6.conf.all.use_tempaddr" = 0;
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.netfilter.nf_conntrack_helper" = 1;
  };

  networking = {
    hostName = "goose";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    useDHCP = false;
    vlans = {
      wifi = {
        id = 100;
        interface = "enp1s0f0";
      };
      wired = {
        id = 101;
        interface = "enp1s0f0";
      };
      guest = {
        id = 150;
        interface = "enp1s0f0";
      };

      mgnt = {
        id = 254;
        interface = "enp1s0f0";
      };
    };

    interfaces = {
      enp7s0 = {
        ipv4 = {
          addresses = [{
            address = "192.168.1.2";
            prefixLength = 24;
          }];
          routes = [{
            address = "172.26.0.0";
            prefixLength = 17;
            via = "192.168.1.1";
          }
            {
              address = "172.23.0.0";
              prefixLength = 17;
              via = "192.168.1.1";
            }
            {
              address = "10.31.255.128";
              prefixLength = 27;
              via = "192.168.1.1";
            }];
        };
      };
      wifi = {
        ipv4.addresses = [{
          address = "10.255.100.254";
          prefixLength = 24;
        }];
      };
      wired = {
        ipv4.addresses = [{
          address = "10.255.101.254";
          prefixLength = 24;
        }];
      };
      guest = {
        ipv4.addresses = [{
          address = "10.255.150.254";
          prefixLength = 24;
        }];
      };

      mgnt = {
        ipv4.addresses = [{
          address = "10.255.254.254";
          prefixLength = 24;
        }];
      };
    };
  };

  services.pppd = {
    enable = true;
    peers = {
      movistar = {
        # Autostart the PPPoE session on boot
        autostart = true;
        enable = true;
        config = ''
          plugin rp-pppoe.so enp7s0
          name "adslppp@telefonicanetpa"
          password "adslppp"
          persist
          maxfail 0
          holdoff 5
          noipdefault
          defaultroute
        '';
      };
    };
  };

  services.lldpd.enable = true;
}

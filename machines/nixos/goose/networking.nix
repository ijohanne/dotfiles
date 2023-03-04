{ interfaces, ... }:

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
        interface = "${interfaces.internal}";
      };
      wired = {
        id = 101;
        interface = "${interfaces.internal}";
      };
      guest = {
        id = 150;
        interface = "${interfaces.internal}";
      };
      mgnt = {
        id = 254;
        interface = "${interfaces.internal}";
      };
      wan = {
        id = 253;
        interface = "${interfaces.internal}";
      };
    };

    bonds."${interfaces.internal}" = {
      interfaces = interfaces.uplinks;
      driverOptions = {
        mode = "802.3ad";
        miimon = "100";
        downdelay = "200";
        updelay = "200";
      };
    };
    interfaces = {
      "${interfaces.external}" = {
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
          plugin rp-pppoe.so ${interfaces.external}
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

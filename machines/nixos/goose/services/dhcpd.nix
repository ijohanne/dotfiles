{ ... }:

{
  services.dhcpd4 = {
    enable = true;
    interfaces = [ "wifi" "wired" "mgnt" ];
    extraConfig = ''
       option subnet-mask 255.255.255.0;
       option deco240 code 240 = string;
       option space ubnt;
       option ubnt.unifi-address code 1 = ip-address;
       option ntp-servers 10.255.100.202;
       option domain-search "est.unixpimps.net", "local";

       class "ubnt" {
         match if substring (option vendor-class-identifier, 0, 4) = "ubnt";
         option vendor-class-identifier "ubnt";
         vendor-option-space ubnt;
       }

       subnet 10.255.100.0 netmask 255.255.255.0 {
         option broadcast-address 10.255.100.255;
         option routers 10.255.100.254;
         option ubnt.unifi-address 10.255.254.240;
         if substring(option vendor-class-identifier, 1, 3) = "IAL" { option domain-name-servers 172.26.23.3; option deco240 ":::::239.0.2.30:22222"; } else { option domain-name-servers 10.255.100.254;}
         default-lease-time 86400;
         max-lease-time 129600;
         interface wifi;
         range 10.255.100.1 10.255.100.200;
       }

       subnet 10.255.101.0 netmask 255.255.255.0 {
         option broadcast-address 10.255.101.255;
         option routers 10.255.101.254;
         option ubnt.unifi-address 10.255.254.240;
         if substring(option vendor-class-identifier, 1, 3) = "IAL" { option domain-name-servers 172.26.23.3; option deco240 ":::::239.0.2.30:22222"; } else { option domain-name-servers 10.255.101.254;}
         default-lease-time 86400;
         max-lease-time 129600;
         interface wired;
         range 10.255.101.1 10.255.101.200;
       }

       subnet 10.255.150.0 netmask 255.255.255.0 {
         option broadcast-address 10.255.150.255;
         option routers 10.255.150.254;
         option domain-name-servers 10.255.150.254;
         default-lease-time 86400;
         max-lease-time 129600;
         interface guest;
         range 10.255.150.1 10.255.150.200;
       }

       subnet 10.255.254.0 netmask 255.255.255.0 {
         option broadcast-address 10.255.254.255;
         option routers 10.255.254.254;
         option ubnt.unifi-address 10.255.254.240;
         option domain-name-servers 10.255.254.254;
         default-lease-time 86400;
         max-lease-time 129600;
         interface mgnt;
         range 10.255.254.1 10.255.254.200;
       }

       host UniFi-CloudKey {
         hardware ethernet d0:21:f9:64:97:b3;
         fixed-address 10.255.254.240;
       }

       host amon {
         hardware ethernet dc:a6:32:60:1c:82;
         fixed-address 10.255.101.241;
       }

       host hp-office {
         hardware ethernet 30:e1:71:09:c3:2e;
         fixed-address 10.255.100.230;
       }

       host Main-bridge {
         hardware ethernet 00:17:88:a7:27:9c;
         fixed-address 10.255.101.240;
       }

       host ij-laptop {
         hardware ethernet c8:e2:65:2d:7e:8b;
         fixed-address 10.255.100.201;
       }

       host chronos {
         hardware ethernet dc:a6:32:34:1e:6e;
         fixed-address 10.255.100.202;
       }

       host hapi {
         hardware ethernet b8:27:eb:ff:f8:5f;
         fixed-address 10.255.101.242;
       }

       host fatty {
         hardware ethernet a8:a1:59:3e:da:ef;
         fixed-address 10.255.101.243;
       }

       host sobek {
         hardware ethernet dc:a6:32:08:7c:33;
         fixed-address 10.255.100.203;
       }

       host sobek-wired {
         hardware ethernet dc:a6:32:08:7c:32;
         fixed-address 10.255.101.244;
       }

       host office-ian-plug {
         hardware ethernet 6c:5a:b0:2e:79:70;
         fixed-address 10.255.100.231;
       }

       host office-martin-plug {
         hardware ethernet 54:af:97:1d:72:c4;
         fixed-address 10.255.100.232;
       }

       host livingroom-heater-plug {
         hardware ethernet 54:af:97:1d:63:6c;
         fixed-address 10.255.100.233;
       }

       host terrace-laundry-plug {
         hardware ethernet 54:af:97:1d:55:e6;
         fixed-address 10.255.100.234;
       }

       host terrace-fridge-plug {
         hardware ethernet 54:af:97:1d:59:d8;
         fixed-address 10.255.100.235;
       }

      host camera-entrance {
         hardware ethernet e8:ca:c8:bf:08:17;
         fixed-address 10.255.100.220;
      }

      host camera-terrace-indoor {
         hardware ethernet e8:ca:c8:7a:83:71;
         fixed-address 10.255.100.221;
      }

      host camera-terrace-outdoor-00 {
         hardware ethernet ec:71:db:68:f9:2e;
         fixed-address 10.255.101.220;
      }

      host camera-terrace-outdoor-01 {
         hardware ethernet ec:71:db:94:da:da;
         fixed-address 10.255.101.221;
      }
    '';
  };

  systemd.services.dhcpd4 = {
    requires = [ "guest-netdev.service" "mgnt-netdev.service" "wifi-netdev.service" "wired-netdev.service" ];
  };
}

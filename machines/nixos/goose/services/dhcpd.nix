{ ... }:

{
  services.dhcpd4 = {
    enable = true;
    interfaces = [ "wifi" "wired" "mgnt" ];
    extraConfig = ''
      option subnet-mask 255.255.255.0;
      option deco240 code 240 = string;
      if substring(option vendor-class-identifier, 0, 3) = "IAL" { option domain-name-servers 172.26.23.3; option deco240 ":::::239.0.2.30:22222"; } else { option domain-name-servers 8.8.8.8, 8.8.4.4;}

      subnet 10.255.100.0 netmask 255.255.255.0 {
        option broadcast-address 10.255.100.255;
        option routers 10.255.100.254;
        interface wifi;
        range 10.255.100.1 10.255.100.253;
      }

      subnet 10.255.101.0 netmask 255.255.255.0 {
        option broadcast-address 10.255.101.255;
        option routers 10.255.101.254;
        interface wired;
        range 10.255.101.1 10.255.101.253;
      }

      subnet 10.255.150.0 netmask 255.255.255.0 {
        option broadcast-address 10.255.150.255;
        option routers 10.255.150.254;
        interface guest;
        range 10.255.150.1 10.255.150.253;
      }

      subnet 10.255.254.0 netmask 255.255.255.0 {
        option broadcast-address 10.255.254.255;
        option routers 10.255.254.254;
        interface mgnt;
        range 10.255.254.1 10.255.254.253;
      }
    '';
  };
}

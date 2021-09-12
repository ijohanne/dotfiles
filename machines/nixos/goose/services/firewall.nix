{ ... }:

{
  networking = {
    nat.enable = false;
    firewall.enable = false;
    nftables = {
      enable = true;
      ruleset = ''
        table ip filter {
            chain output {
              type filter hook output priority 100; policy accept;
            }

            chain input {
              type filter hook input priority filter; policy drop;
              ip saddr 10.0.0.0/8 tcp dport 53 accept;
              ip saddr 10.0.0.0/8 udp dport 53 accept;
              ip protocol icmp accept;
              ip saddr 0.0.0.0/0 udp dport 51820 accept;
              ip saddr 0.0.0.0/0 tcp dport 80 accept;
              ip saddr 0.0.0.0/0 tcp dport 443 accept;

              iifname {
                "wifi",
                "wired",
                "mgnt",
                "enp7s0",
                "lo",
                "wg0"
              } counter accept
              ip protocol igmp accept comment "Accept IGMP"
              iifname "ppp0" ct state { established, related } counter accept
              iifname "ppp0" drop
              ip saddr 224.0.0.0/4 accept
            }

            chain forward {
              meta oiftype ppp tcp flags syn tcp option maxseg size set 1452
              type filter hook forward priority filter; policy drop;
              iifname { "wifi", "wired", "mgnt", "enp7s0", "wg0" } oifname {
                "ppp0", "enp1s0f1"
              } counter accept

              iifname {
                "ppp0", "enp1s0f1"
              } oifname { "wifi", "wired", "mgnt", "enp7s0", "wg0"
              } ct state established,related counter accept

              iifname { "wifi", "wired", "mgnt", "enp7s0", "wg0" } oifname {
                "wifi", "wired", "mgnt", "enp7s0", "wg0" } counter accept
              ip saddr 172.26.0.0/16 ip daddr 224.0.0.0/4 accept
              ip saddr 172.23.0.0/16 ip daddr 224.0.0.0/4 accept
            }
        }

        table ip nat {
            chain prerouting {
              type nat hook output priority filter; policy accept;
            }

            chain postrouting {
              type nat hook postrouting priority filter; policy accept;
              oifname "ppp0" masquerade
              oifname "enp1s0f1" masquerade
            }
        }
      '';
    };
  };
}

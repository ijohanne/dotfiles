{ interfaces, ... }:

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
                      "${interfaces.external}",
                      "lo",
                      "wg0"
                    } counter accept
                    ip protocol igmp accept comment "Accept IGMP"
                    ip saddr 224.0.0.0/4 accept
                    iifname "ppp0" ct state { established, related } counter accept
                    iifname "ppp0" drop
                  }

                  chain forward {
                    meta oiftype ppp tcp flags syn tcp option maxseg size set 1452
                    type filter hook forward priority filter; policy drop;
                    ip protocol { tcp , udp } flow offload @fastnat;
                    iifname { "wifi", "wired", "mgnt", "${interfaces.external}", "wg0" } oifname {
                      "ppp0", "${interfaces.external}"
                    } counter accept

                    iifname {
                      "ppp0", "${interfaces.external}"
                    } oifname { "wifi", "wired", "mgnt", "${interfaces.external}", "wg0"
                    } ct state established,related counter accept

                    iifname { "wifi", "wired", "mgnt", "${interfaces.external}", "wg0" } oifname {
                      "wifi", "wired", "mgnt", "${interfaces.external}", "wg0" } counter accept

                    ip saddr 172.26.0.0/16 accept
                    ip saddr 172.23.0.0/16 accept
                  }

                  flowtable fastnat {
                    hook ingress priority 0
                    devices = { wifi, wired, mgnt, ${interfaces.external} }
                  }
              }

              table ip nat {
                  chain prerouting {
                    type nat hook prerouting priority -100; policy accept;
        iifname "${interfaces.external}" ip saddr 172.26.0.0/16 dnat to 10.255.101.47
        iifname "${interfaces.external}" ip saddr 172.23.0.0/16 dnat to 10.255.101.47
                  }

                  chain postrouting {
                    type nat hook postrouting priority filter; policy accept;
                    oifname "ppp0" masquerade
                    oifname "${interfaces.external}" masquerade
                  }
              }
      '';
    };
  };
}

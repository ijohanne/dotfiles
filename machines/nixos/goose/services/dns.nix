{ ... }:
{
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 2097152;
  };
  services.unbound = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      server = {
        module-config = [ "validator" "python" "iterator" ];
        interface = [ "0.0.0.0" "127.0.0.1" ];
        access-control = [ "10.0.0.0/8 allow" "127.0.0.0/8 allow" ];
        root-hints = builtins.fetchurl {
          url = https://www.internic.net/domain/named.root;
        };
        do-tcp = "yes";
        do-udp = "yes";
        hide-identity = "yes";
        hide-version = "yes";
        harden-glue = "yes";
        harden-dnssec-stripped = "yes";
        use-caps-for-id = "yes";
        cache-min-ttl = 0;
        cache-max-ttl = 3600;
        prefetch = "yes";
        num-threads = 8;
        msg-cache-slabs = 8;
        rrset-cache-slabs = 8;
        infra-cache-slabs = 8;
        key-cache-slabs = 8;
        rrset-cache-size = "256m";
        msg-cache-size = "128m";
        so-rcvbuf = "1m";
        statistics-interval = 0;
        extended-statistics = "yes";
        statistics-cumulative = "yes";
        local-data = [
          ''"r0.est.unixpimps.net. IN A 10.255.254.254"''
          ''"cloudkey.est.unixpimps.net. IN A 10.255.254.240"''
          ''"hp-office.est.unixpimps.net. IN A 10.255.101.230"''
          ''"sobek.est.unixpimps.net. IN A 10.255.100.203"''
          ''"fatty.est.unixpimps.net. IN A 10.255.101.243"''
          ''"chronos.est.unixpimps.net. IN A 10.255.100.202"''
          ''"hapi.est.unixpimps.net. IN A 10.255.101.242"''
          ''"grafana.est.unixpimps.net. IN A 10.255.254.254"''
          ''"app-backend.local. IN A 10.255.100.201"''
          ''"app-frontend.local. IN A 10.255.100.201"''
        ];
      };
      remote-control = {
        control-enable = true;
        control-use-cert = "no";
      };
    };
  };
}

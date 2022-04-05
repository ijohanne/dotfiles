{ secrets, ... }:
{
  services.prometheus-tplink-p110-exporter = {
    enable = true;
    enableLocalScraping = true;
    username = secrets.tplink.username;
    password = secrets.tplink.password;
    hosts = [ "10.255.100.231" "10.255.100.232" "10.255.100.233" "10.255.100.234" "10.255.100.235" ];
  };
}

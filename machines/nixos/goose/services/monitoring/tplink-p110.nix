{ secrets, ... }:
{
  services.prometheus-tplink-p110-exporter = {
    enable = true;
    enableLocalScraping = true;
    username = secrets.tplink.username;
    password = secrets.tplink.password;
    hosts = [ "10.255.100.231" ];
  };
}

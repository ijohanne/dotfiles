{ secrets, ... }:
{
  services.prometheus-unpoller-exporter = {
    enable = true;
    enableLocalScraping = true;
    unifiUrl = "https://10.255.254.240:8443";
    unifiUsername = secrets.cloudKey.username;
    unifiPassword = secrets.cloudKey.password;
  };
}

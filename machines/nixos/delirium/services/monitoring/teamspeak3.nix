{ secrets, ... }:
{
  services.prometheus-teamspeak3-exporter = {
    enable = true;
    enableLocalScraping = true;
    remotePassword = secrets.teamspeak3.serveradmin;
  };
}

{ secrets, ... }:
{
  services.prometheus-netatmo-exporter = {
    enable = true;
    enableLocalScraping = true;
    clientId = secrets.netatmo.clientId;
    clientSecret = secrets.netatmo.clientSecret;
    username = secrets.netatmo.username;
    password = secrets.netatmo.password;
  };
}

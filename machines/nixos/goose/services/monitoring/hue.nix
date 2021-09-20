{ secrets, ... }:
{
  services.prometheus-hue-exporter = {
    enable = true;
    enableLocalScraping = true;
    hueUrl = "10.255.101.240";
    hueApiKey = secrets.hueApiKey;
  };
}

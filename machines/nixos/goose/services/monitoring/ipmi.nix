{ ... }:
{
  services.prometheus-ipmi-exporter = {
    enable = true;
    enableLocalScraping = true;
  };
}

{ ... }:
{
  services.prometheus-nftables-exporter = {
    enable = true;
    enableLocalScraping = true;
  };
}

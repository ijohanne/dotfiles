{ pkgs, config, lib, ... }:
{
  services.nginx.virtualHosts = {
    "unixpimps.net" = {
      serverAliases = [ "www.unixpimps.net" ];
      http2 = true;
      forceSSL = true;
      enableACME = true;
      root = "/var/www/unixpimps.net/html";
      default = true;
    };
    "shouldidrink.today" = {
      serverAliases = [ "www.shouldidrink.today" ];
      http2 = true;
      forceSSL = true;
      enableACME = true;
      root = "/var/www/shouldidrink.today/html";
    };
  };
}

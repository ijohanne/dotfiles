{ ... }:
{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;

    virtualHosts."printcam.est.unixpimps.net" = {
      enableACME = true;
      onlySSL = true;
      locations."/" = {
        proxyPass = "http://10.255.101.244/webcam/?action=stream";
      };
    };
  };

  security.acme = {
    email = "sysops@unixpimps.net";
    acceptTerms = true;
  };

}
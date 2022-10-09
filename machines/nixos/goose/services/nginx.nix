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

    virtualHosts."obico.est.unixpimps.net" = {
      enableACME = true;
      onlySSL = true;
      locations."/" = {
        proxyPass = "http://10.255.101.91:3334/";
        proxyWebsockets = true;
      };
    };

  };

  security.acme = {
    defaults.email = "sysops@unixpimps.net";
    acceptTerms = true;
  };

}

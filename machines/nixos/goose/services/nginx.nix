{ ... }:
{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
  };

  security.acme = {
    email = "sysops@unixpimps.net";
    acceptTerms = true;
  };

}

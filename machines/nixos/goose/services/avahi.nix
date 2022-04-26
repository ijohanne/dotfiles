{ ... }:

{
  services.avahi = {
    enable = true;
    nssmdns = true;
    reflector = true;
    ipv6 = false;
    allowPointToPoint = true;
    interfaces = [
      "wifi"
      "wired"
      "mgnt"
    ];
  };
}

{ ... }:

{
  services.avahi = {
    enable = true;
    nssmdns = true;
    reflector = true;
    ipv6 = false;
    allowPointToPoint = true;
    cacheEntriesMax = 0;
    interfaces = [
      "wifi"
      "wired"
      "mgnt"
    ];
  };
}

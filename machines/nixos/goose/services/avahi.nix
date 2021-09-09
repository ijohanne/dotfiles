{ ... }:

{
  services.avahi = {
    enable = true;
    nssmdns = true;
    reflector = true;
    allowPointToPoint = true;
    interfaces = [
      "wifi"
      "wired"
      "mgnt"
    ];
  };
}

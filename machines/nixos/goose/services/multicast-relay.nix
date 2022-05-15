{ ... }:

{
  services.multicast-relay = {
    enable = true;
    interfaces = [
      "wifi"
      "wired"
    ];
  };
}

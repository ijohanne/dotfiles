{ ... }:
{
  imports = [
    ./dns.nix
    ./firewall.nix
    ./avahi.nix
    ./igmpproxy.nix
    ./dhcpd.nix
  ];
  services.openssh.permitRootLogin = "prohibit-password";
  services.xserver = { enable = false; };
  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 ];
}

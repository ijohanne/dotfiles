{ secrets, pkgs, ... }:
{
  imports = [
    ./dns.nix
    ./firewall.nix
    ./avahi.nix
    ./igmpproxy.nix
    ./dhcpd.nix
    ./wireguard.nix
    (import ./cloudflare.nix { inherit secrets pkgs; })
  ];
  services.openssh.permitRootLogin = "prohibit-password";
  services.xserver = { enable = false; };
  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 ];
}

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
  services.openssh = {
    enable = true;
    permitRootLogin = "prohibit-password";
    passwordAuthentication = false;
  };

  services.xserver = { enable = false; };

  networking.firewall.allowedTCPPorts = [ 22 ];
}

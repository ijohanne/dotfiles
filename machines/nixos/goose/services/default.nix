{ config, secrets, pkgs, ... }:
{
  imports = [
    ./dns.nix
    ./firewall.nix
    ./avahi.nix
    ./igmpproxy.nix
    ./dhcpd.nix
    ./wireguard.nix
    ./nginx.nix
    ./multicast-relay.nix
    (import ./monitoring { inherit secrets config pkgs; })
    (import ./prometheus.nix { inherit pkgs config secrets; })
    (import ./cloudflare.nix { inherit secrets pkgs; })
  ];
  services.openssh = {
    enable = true;
    permitRootLogin = "prohibit-password";
    passwordAuthentication = false;
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
  };
  services.xserver = { enable = false; };
}

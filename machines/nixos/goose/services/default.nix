{ config, secrets, pkgs, interfaces, ... }:
{
  imports = [
    ./dns.nix
    (import ./firewall.nix { inherit interfaces; })
    ./avahi.nix
    (import ./igmpproxy.nix { inherit pkgs interfaces; })
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
  services.vnstat = { enable = true; };
}

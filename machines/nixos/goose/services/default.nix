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
    (import ./prometheus.nix { inherit config secrets; })
    (import ./prometheus-node.nix { inherit config; })
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

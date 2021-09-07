{ ... }:
{
  imports = [
  ];
  services.openssh.permitRootLogin = "prohibit-password";
  services.xserver = { enable = false; };
  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 ];
}

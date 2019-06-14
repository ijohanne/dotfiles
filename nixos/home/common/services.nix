{ pkgs, ... }:

{
  services.gpg-agent.enable = true;
  services.network-manager-applet.enable = true;
}

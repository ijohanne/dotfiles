{ pkgs, ... }:

{
  services.gnome-keyring.enable = true;
  services.gpg-agent.enable = true;
  services.network-manager-applet.enable = true;
}

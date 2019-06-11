{ pkgs, ... }:

{
  services.screen-locker = {
    enable = true;
    inactiveInterval = 10;
  };

  services.gnome-keyring.enable = true;
  services.gpg-agent.enable = true;
  services.network-manager-applet.enable = true;

}
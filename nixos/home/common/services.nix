{ pkgs, ... }:

{
  services.screen-locker = {
    enable = true;
    lockCmd = "xlock -mode xjack -erasedelay 0";
  };

  services.gnome-keyring.enable = true;
  services.gpg-agent.enable = true;
  services.network-manager-applet.enable = true;
}
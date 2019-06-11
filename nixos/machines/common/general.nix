{ config, pkgs, ... }:

{
  nixpkgs.config = {
    packageOverrides = pkgs: {
      bluez = pkgs.bluez5;
   };
  };
  
  i18n = {
     consoleFont = "Lat2-Terminus16";
     consoleKeyMap = "us";
     defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Madrid";

  environment.systemPackages = with pkgs; [
     wget binutils unzip zip docker zsh
  ];

  services = {
    printing.enable = true;
    openssh.enable = true;
    dbus.packages = [ pkgs.blueman ];
  };

  system.stateVersion = "19.03";

  services.xserver = {
    enable = true;
    layout = "us";
    desktopManager =  {
      gnome3.enable = true;
      default = "gnome3";
    };
    displayManager.lightdm  = {
      enable = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
}
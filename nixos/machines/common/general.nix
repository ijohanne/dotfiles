{ config, pkgs, ... }:

{
  nixpkgs.config = { packageOverrides = pkgs: { bluez = pkgs.bluez5; }; };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Madrid";

  environment.systemPackages = with pkgs; [
    wget
    binutils
    unzip
    zip
    docker
    zsh
  ];

  services = {
    openssh.enable = true;
    dbus.packages = [ pkgs.blueman ];
  };

  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint pkgs.hplipWithPlugin ];
  };

  system.stateVersion = "19.03";

  services.xserver = {
    enable = true;
    autorun = false;
    layout = "us";
    desktopManager = {
      default = "none";
      xterm.enable = false;
    };
  };

  programs.sway.enable = true;

  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;
}

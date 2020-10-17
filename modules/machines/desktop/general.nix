{ lib, pkgs, config, ... }:
with lib; {
  config = lib.mkIf (config.dotfiles.machines.desktop) {
    nixpkgs.config = { packageOverrides = pkgs: { bluez = pkgs.bluez5; }; };

    i18n = { defaultLocale = "en_US.UTF-8"; };

    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    time.timeZone = "Europe/Madrid";

    environment.systemPackages = with pkgs; [ wget binutils unzip zip docker ];

    services = {
      openssh = {
        enable = true;
        permitRootLogin = "prohibit-password";
        passwordAuthentication = false;
      };
      dbus.packages = [ pkgs.blueman ];
    };

    services.xserver = {
      enable = true;
      autorun = false;
      layout = "us";
      desktopManager = { xterm.enable = false; };
      displayManager = { defaultSession = "sway"; };
      videoDrivers = [ "amdgpu" ];
    };

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    virtualisation = {
      docker = {
        enable = true;
        storageDriver = "devicemapper";
        extraOptions = "--storage-opt  dm.basesize=50G";
      };
      libvirtd.enable = true;
    };

    services.printing.enable = true;
    services.avahi.enable = true;
    services.avahi.nssmdns = true;
  };
}
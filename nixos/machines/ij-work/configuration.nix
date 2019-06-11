{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      bluez = pkgs.bluez5;
   };
  };

  networking.hostName = "ij-laptop";
  networking.networkmanager.enable = true;
  networking.hostId = "d4c95480";

  i18n = {
     consoleFont = "Lat2-Terminus16";
     consoleKeyMap = "us";
     defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Madrid";

  environment.systemPackages = with pkgs; [
     wget binutils unzip zip docker zsh
  ];

  hardware.enableAllFirmware = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };
  
  hardware.bluetooth = {
    enable = true;
      extraConfig = ''
      [General]
        Enable=Source,Sink,Media,Socket
        ControllerMode = bredr
    '';
  };

  services = {
    printing.enable = true;
    openssh.enable = true;
    dbus.packages = [ pkgs.blueman ];
  };

  users.users.ij = {
	isNormalUser = true;
	name = "ij";
	group = "adm";
	extraGroups = [ "wheel" "disk" "audio" "video" "networkmanager" "systemd-journal" ];
	createHome = true;
	uid = 1000;
	home = "/home/ij";
	};

  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  users.mutableUsers = true;

  system.stateVersion = "19.03";


  boot.initrd.luks.devices.decrypted-disk-name = {
    device = "/dev/disk/by-uuid/6e06a844-d428-4e2f-b3c1-91a7581cdb08";
    keyFile = "/keyfile.bin";
  };

  boot.loader = {
    efi.efiSysMountPoint = "/efi";

    grub = {
      device = "nodev";
      efiSupport = true;
      extraInitrd = "/boot/initrd.keys.gz";
      enableCryptodisk = true;
      zfsSupport = true;
    };

    grub.efiInstallAsRemovable = true;
    efi.canTouchEfiVariables = false;
  };

  services.xserver = {
    enable = true;
    layout = "us";
    desktopManager =  {
      gnome3.enable = true;
      default = "gnome3";
    };
    displayManager.gdm  = {
      enable = true;
      wayland = false;
    };
  };

  nixpkgs.config.allowUnfree = true;
}

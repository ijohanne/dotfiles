{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

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
     wget vim binutils firefox unzip zip docker zsh
  ];

  hardware.bluetooth.enable = false;
  hardware.enableAllFirmware = true;
  hardware.pulseaudio.enable = true;

  services = {
    printing.enable = true;
    openssh.enable = true;
  }

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
    device = "/dev/disk/by-uuid/55766568-7907-4916-9243-27d583aec775";
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

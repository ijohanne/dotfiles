{ config, ... }:

let
  pkgs = import (builtins.fetchTarball {
    inherit ((import ../../nix/sources.nix).nixpkgs) url sha256;
  }) { config = config.nixpkgs.config; };

in {
  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    loader = {
      grub.enable = false;
      raspberryPi = {
        enable = true;
        version = 4;
      };
    };
  };

  hardware.enableRedistributableFirmware = true;

  networking.wireless.enable = false;
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  time.timeZone = "Europe/Madrid";

  i18n = { defaultLocale = "en_US.UTF-8"; };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment.systemPackages = with pkgs; [ wget binutils unzip zip docker ];

  services = {
    openssh = {
      enable = true;
      permitRootLogin = "prohibit-password";
      passwordAuthentication = false;
    };
  };

  services.xserver = { enable = false; };

  nixpkgs.config.allowUnfree = true;
}


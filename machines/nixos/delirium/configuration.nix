{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  environment.systemPackages = with pkgs; [ ripgrep vim nixpkgs-fmt htop fish git ];

  boot.kernelPackages = pkgs.linuxPackages_5_13;
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    mirroredBoots = [
      { devices = [ "nodev" ]; path = "/boot/ESP0"; }
      { devices = [ "nodev" ]; path = "/boot/ESP1"; }
    ];
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/EFI";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "delirium";
  environment.etc."mdadm.conf".text = ''
    HOMEHOST delirium
  '';
  boot.initrd.mdadmConf = config.environment.etc."mdadm.conf".text;

  networking.useDHCP = false;
  networking.interfaces."eno1".ipv4.addresses = [
    {
      address = "141.94.130.22";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = "141.94.130.254";
  networking.nameservers = [ "8.8.8.8" ];

  users.users.root.initialHashedPassword = "";
  services.openssh.permitRootLogin = "prohibit-password";
  services.xserver = { enable = false; };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKeFunHfY3vS2izkp7fMHk2bXuaalNijYcctAF2NGc1T"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKiCGBgFgwbHB+2m++ViEnhoFjww2Twvx8gXWcMvHvz3 martin@martin8412.dk"
  ];
  users.users = {
    mj = {
      createHome = true;
      description = "Martin Karlsen Jensen";
      extraGroups = [
        "wheel"
      ];
      group = "adm";
      isNormalUser = true;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKiCGBgFgwbHB+2m++ViEnhoFjww2Twvx8gXWcMvHvz3 martin@martin8412.dk"
      ];
    };
    ij = {
      createHome = true;
      description = "Ian Johannesen";
      extraGroups = [
        "wheel"
      ];
      group = "adm";
      isNormalUser = true;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKeFunHfY3vS2izkp7fMHk2bXuaalNijYcctAF2NGc1T"
      ];
    };

  };

  nix.maxJobs = lib.mkDefault 64;

  services.openssh.enable = true;
  system.stateVersion = "21.05";

  security.sudo = {
    enable = true;
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

  services.transmission = {
    enable = true;
    openFirewall = true;
    performanceNetParameters = true;
    port = 8000;
    settings = {
      download-dir = "/var/data/Downloads";
      incomplete-dir = "/var/data/incomplete";
      incomplete-dir-enabled = true;
      watch-dir = "/var/data/watchdir";
      watch-dir-enabled = true;
      message-level = 1;
      peer-port = 51413;
      peer-port-random-high = 65535;
      peer-port-random-low = 49152;
      peer-port-random-on-start = false;
      rpc-port = 9091;
      umask = 2;
    };
  };

}

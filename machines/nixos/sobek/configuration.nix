{ pkgs, config, ... }:

let
  sources = (import ./nix/sources.nix);
  ijohanne-nur = import sources.nur-packages { inherit pkgs; };
  nixpkgs-tars = "https://github.com/NixOS/nixpkgs/archive/";
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ijohanne-nur.modules.mjpg-streamer-experimental
    ];

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = _: {
      pr165328 = import
        (fetchTarball
          "${nixpkgs-tars}48e0651a716f57a46928fc14353cf090152511c9.tar.gz")
        { config = config.nixpkgs.config; };
    };
  };

  nixpkgs.overlays = [
    (import "${sources.nur-packages}/overlay.nix")
    (_: super: {
      octoprint = super.pr165328.octoprint.override {
        packageOverrides =
          self: super: {
            arcwelder =
              self.buildPythonPackage rec {
                pname = "OctoPrintPlugin-ArcWelder";
                propagatedBuildInputs = [ super.octoprint ];
                doCheck = false;
                version = "master";
                src = pkgs.fetchFromGitHub { inherit (sources.ArcWelderPlugin) owner repo rev sha256; };
              };
            obico =
              self.buildPythonPackage rec {
                pname = "OctoPrintPlugin-Obico";
                propagatedBuildInputs = with super; [ octoprint backoff raven bson ];
                doCheck = false;
                version = "master";
                src = pkgs.fetchFromGitHub { inherit (sources.OctoPrint-Obico) owner repo rev sha256; };
              };
            printscheduler =
              self.buildPythonPackage rec {
                pname = "OctoPrintPlugin-PrintScheduler";
                propagatedBuildInputs = with super; [ octoprint backports-datetime-fromisoformat ];
                doCheck = false;
                version = "master";
                src = pkgs.fetchFromGitHub { inherit (sources.OctoPrint-PrintScheduler) owner repo rev sha256; };
              };
            bedlevelvisualizer =
              self.buildPythonPackage rec {
                pname = "OctoPrint-BedLevelVisualizer";
                propagatedBuildInputs = [ super.octoprint ];
                doCheck = false;
                version = "master";
                src = pkgs.fetchFromGitHub { inherit (sources.OctoPrint-BedLevelVisualizer) owner repo rev sha256; };
              };
            octoprint-dashboard = self.buildPythonPackage rec {
              pname = "OctoPrint-Dashboard";
              propagatedBuildInputs = [ super.octoprint ];
              doCheck = false;
              version = "master";
              src = pkgs.fetchFromGitHub { inherit (sources.OctoPrint-Dashboard) owner repo rev sha256; };
            };
            displaylayerprogress = self.buildPythonPackage rec {
              pname = "OctoPrint-DusplayLayerProgress";
              propagatedBuildInputs = [ super.octoprint ];
              doCheck = false;
              version = "master";
              src = pkgs.fetchFromGitHub { inherit (sources.OctoPrint-DisplayLayerProgress) owner repo rev sha256; };
            };

          };
      };
    })
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{serial}=="31F9D4B7", ATTR{idVendor}=="046d", ATTR{idProduct}=="085e", NAME="video0"
    SUBSYSTEM=="vchiq",GROUP="video",MODE="0660"
  '';

  networking.hostName = "sobek"; # Define your hostname.
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Madrid";
  networking.useDHCP = false;
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.enable = false;
  services.openssh.enable = true;
  programs.ssh.extraConfig = ''
    Host builder
        HostName 141.94.130.22
        Port 22
        User builder
        IdentitiesOnly yes
        IdentityFile /root/.ssh/id_ed25519
  '';
  services.octoprint = {
    enable = true;
    plugins = _: with pkgs.octoprint.python.pkgs; [ printtimegenius arcwelder printscheduler themeify bedlevelvisualizer simpleemergencystop octoprint-dashboard displaylayerprogress obico ];
  };
  systemd.services.octoprint.path = [ pkgs.libraspberrypi ];
  networking.firewall.enable = false;
  services.mjpg-streamer-experimental = {
    enable = true;
    inputArgs = "-d /dev/video0 -r 1920x1080 -f 60";
  };

  security.sudo = {
    enable = true;
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

  environment.systemPackages = with pkgs; [
    (neovim.override {
      viAlias = true;
      vimAlias = true;
    })
    screen
    bottom
    htop
    git
    libraspberrypi
    raspberrypifw
    raspberrypi-eeprom
    niv
    nixpkgs-fmt
    v4l-utils
    ripgrep
    gping
  ];

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;

    virtualHosts.default = {
      default = true;
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:5000/";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Origin "";
                  client_max_body_size 0;
          '';
        };
        "/webcam/" = {
          proxyPass = "http://127.0.0.1:8080/";
        };
      };
    };
  };

  users.users.mj = {
    createHome = true;
    description = "Martin Karlsen Jensen";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    group = "adm";
    isNormalUser = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKiCGBgFgwbHB+2m++ViEnhoFjww2Twvx8gXWcMvHvz3 martin@martin8412.dk"
    ];
  };

  users.users.ij = {
    createHome = true;
    description = "Ian Johannesen";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    group = "adm";
    isNormalUser = true;
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKeFunHfY3vS2izkp7fMHk2bXuaalNijYcctAF2NGc1T ij@opsplaza.com"
    ];
  };

  users.users.octoprint = {
    extraGroups = [
      "video"
    ];
  };


  nix.buildMachines = [{
    hostName = "builder";
    systems = [ "x86_64-linux" "aarch64-linux" ];
    maxJobs = 4;
    speedFactor = 2;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    mandatoryFeatures = [ ];
  }];
  nix.distributedBuilds = true;
  # optional, useful when the builder has a faster internet connection than yours
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  system.stateVersion = "22.05";
}

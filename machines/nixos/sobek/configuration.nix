{ pkgs, ... }:

let
  sources = (import ./nix/sources.nix);
  ijohanne-nur = import sources.nur-packages { inherit pkgs; };
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
  };

  nixpkgs.overlays = [
    (import "${sources.nur-packages}/overlay.nix")
    (_: super: {
      octoprint = super.octoprint.override {
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
            printscheduler =
              self.buildPythonPackage rec {
                pname = "OctoPrintPlugin-PrintScheduler";
                propagatedBuildInputs = with super; [ octoprint backports-datetime-fromisoformat ];
                doCheck = false;
                version = "master";
                src = pkgs.fetchFromGitHub { inherit (sources.OctoPrint-PrintScheduler) owner repo rev sha256; };
              };
          };
      };
    })
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{serial}=="31F9D4B7", ATTR{idVendor}=="046d", ATTR{idProduct}=="085e", NAME="video0"
  '';

  networking.hostName = "sobek"; # Define your hostname.
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Madrid";
  networking.useDHCP = false;
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.enable = false;
  services.openssh.enable = true;
  services.octoprint = {
    enable = true;
    plugins = _: with pkgs.octoprint.python.pkgs; [ printtimegenius arcwelder printscheduler themeify ];
  };
  networking.firewall.enable = false;
  services.mjpg-streamer-experimental.enable = true;

  security.sudo = {
    enable = true;
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

  environment.systemPackages = with pkgs; [ neovim screen bottom htop libraspberrypi raspberrypifw raspberrypi-eeprom niv nixpkgs-fmt ];

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


  system.stateVersion = "22.05";
}

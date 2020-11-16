{ lib, pkgs, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.machines.desktop) {
    nixpkgs.config = { packageOverrides = pkgs: { bluez = pkgs.bluez5; }; };

    i18n = { defaultLocale = "en_US.UTF-8"; };

    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    time.timeZone = "Europe/Madrid";

    environment.systemPackages = with pkgs;
      [
        wget
        binutils
        unzip
        zip
        docker
        yubico-piv-tool
        yubikey-personalization
        yubioath-desktop
        yubikey-personalization-gui
        yubikey-manager
        nur-ijohanne.sddmThemes.sddm-chili
      ] ++ (with pkgs.qt5; [ qtbase qtquickcontrols qtgraphicaleffects ]);

    programs = {
      sway = {
        enable = true;
        wrapperFeatures.gtk = true;
      };
    };

    services = {
      udev.packages = with pkgs; [ yubikey-personalization ];
      printing.enable = true;
      openssh = {
        enable = true;
        permitRootLogin = "prohibit-password";
        passwordAuthentication = false;
      };
      pcscd.enable = true;
      xserver = {
        enable = true;
        layout = "us";
        libinput.enable = true;
        desktopManager = { xterm.enable = false; };
        displayManager = { defaultSession = "sway"; };
        videoDrivers = [ "amdgpu" ];
        displayManager = {
          sddm = {
            enable = true;
            theme = "chili";
          };
        };
      };
      avahi = {
        enable = true;
        nssmdns = true;
      };

      dbus.packages = [ pkgs.blueman ];
    };

    virtualisation = {
      docker = {
        enable = true;
        storageDriver = "devicemapper";
        extraOptions = "--storage-opt  dm.basesize=50G";
      };
      libvirtd.enable = true;
    };

    security.pam = {
      u2f = {
        enable = true;
        cue = true;
      };
      services."sshd".u2fAuth = false;
    };
  };
}

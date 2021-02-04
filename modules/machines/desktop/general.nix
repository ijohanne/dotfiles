{ lib, pkgs, config, ... }:
with lib;
{
  config = mkIf (config.dotfiles.machines.desktop) (
    mkMerge [
      {
        nixpkgs.config = { packageOverrides = pkgs: { bluez = pkgs.bluez5; }; };
        nixpkgs.config.firefox.enableFXCastBridge = true;

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
            sddmThemes.sddm-chili
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
          accounts-daemon.enable = true;
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
            appId = "pam://localhost";
          };
          services."sshd".u2fAuth = false;
        };
      }
      (
        mkIf (config.dotfiles.user-settings.yubikey.username != null) {
          services.udev.extraRules = ''
            ACTION=="bind", \
            ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0407", ENV{ID_SECURITY_TOKEN}="1", DRIVER=="usbhid", \
            ENV{ID_SMARTCARD_READER}="1" \
            TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="yubikey-card-changed.service"

            ACTION=="remove", ENV{ID_USB_INTERFACE_NUM}=="00", \
            ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0407", ENV{ID_SECURITY_TOKEN}="1", \
            TAG+="systemd", RUN+="${getBin pkgs.procps}/bin/pkill -USR1 swayidle"
          '';

        }
      )
    ]
  );
}

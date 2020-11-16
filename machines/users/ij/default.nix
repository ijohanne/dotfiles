{ pkgs, ... }: {
  dotfiles = {
    cachix = {
      binaryCaches = [ "ijohanne.cachix.org" ];
      binaryCachePublicKeys = [ "ijohanne.cachix.org-1:oDy0m6h+CimPEcaUPaTZpEyVk6FVFpYPAXrrA9L5i9M=" ];
    };
    user-settings = {
      git = {
        commit-name = "Ian Johannesen";
        commit-email = "ij@opsplaza.com";
      };
      gpg = {
        git-key = "6BD2201A9B42D8A4A7B70371D144CA04735855AC";
        ssh-keys = [ "155285F1319ACA9CA9A9CA3E258C23D13AE38CF3" ];
        public-keys = [{
          key-file = ./gpg-key-2DEB54D1D4413780.asc;
          key-id = "2DEB54D1D4413780";
          owner-trust = "4E51818D29D2A91BEBE3A7D02DEB54D1D4413780:6:";
        }];
      };
      face-icon = ../../../images/face-icons/ij.png;
      yubikey = {
        u2f-keys = [
          "ij:DB+R6Satvhwm2P78q4VGIPz3TxYbbi5ryXDyOnXR4KT1SjLGayXYjDilP6etAMfbZifLFGmKK0219uhRcpt6jg==,XYZpZgCw5Zz7YfAY1yxsth/yLTKfrsS4OdDlDEv95OETVEPmB35ItLmWQynxRq5eqC2/qJISkCnet7s7JvNQwQ==,es256,+presence⏎"
        ];
        luks-gpg = {
          public-key-file = ./gpg-key-2DEB54D1D4413780.asc;
          encrypted-pass-file = ./encrypted-luks-pass.asc;
        };
      };
      dictionaries = with pkgs.hunspellDicts; [ da_DK en_GB-large ];
    };
  };
}

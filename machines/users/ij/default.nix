{ pkgs, ... }: {
  dotfiles = {
    cachix = {
      binaryCaches = [ "https://ijohanne.cachix.org" ];
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
        username = "ij";
        u2f-keys = [
          "WRBPRCJi8w9v3bY39OS3uJImU8EbnzZSZcazrSUZtzic4NFN1VcEoI3qwX/au/lMcTa8BqSyB3l+cF/UcbZ4SQ==,06Q6q6qoD+4+Ia6V24D/b+iGFUkB8z/EdWxGBmAWIdgpusyse/08bgQz53UruemBUZI2nKr7MYBlgZ+QlryydQ==,es256,+presence"
          "DB+R6Satvhwm2P78q4VGIPz3TxYbbi5ryXDyOnXR4KT1SjLGayXYjDilP6etAMfbZifLFGmKK0219uhRcpt6jg==,XYZpZgCw5Zz7YfAY1yxsth/yLTKfrsS4OdDlDEv95OETVEPmB35ItLmWQynxRq5eqC2/qJISkCnet7s7JvNQwQ==,es256,+presence"
          "ekYwAhvVyLax26rKwdlblNJU0NHdEvwvltZ4EGya8v6YP/etxXAagemPB92uDYQMKXQQygpA1MWiJMdsmJYJHg==,1+OQ/w+votzenmDbQXPRqNTNhUu17l1c2bDZxG+dtYMjZpxQVZbxzxZHYpoNgvNKkeOjBw4iXMGbOscvXY0Orw==,es256,+presence"
          "JkhD07QUvRzF8YCDz18rrOUH4trZe0oZM5YJtc4S8EmjxIa2sL5j/lRwfAz2ePJva2eo6uw20ilfM7QufTWf0Q==,kPKy5qF2jxypQ6yPrvsa+Rjkz6b5VoApbz52eyCD9FSQkfulsXc0UncCtrp1mTqKgbT+RHCk7LJODvWJju27WQ==,es256,+presence"
        ];
        luks-gpg = {
          public-key-file = ./gpg-key-2DEB54D1D4413780.asc;
          encrypted-pass-file = ./encrypted-luks-pass.asc;
        };
      };
      dictionaries = with pkgs.hunspellDicts; [ da_DK en_GB-large ];
      trustedSshHosts = [
        {
          hostname = "delirium.unixpimps.net";
          forwardAgent = true;
          forwardGpgTo = "/run/user/1001/gnupg/S.gpg-agent";
        }
        {
          hostname = "r0.est.unixpimps.net";
          forwardAgent = true;
          forwardGpgTo = "/run/user/1000/gnupg/S.gpg-agent";
        }
        {
          hostname = "pakhet.est.unixpimps.net";
          forwardAgent = true;
          forwardGpgTo = "/run/user/1000/gnupg/S.gpg-agent";
        }

      ];
    };
  };
}

{ lib, config, ... }:
with lib; {
  options.dotfiles.user-settings = {
    gpg = {
      git-key = mkOption {
        default = null;
        type = with types; nullOr str;
        description = "GPG key to use for Git";
      };
      ssh-keys = mkOption {
        default = [ ];
        type = with types; listOf str;
        description = "GPG key(s) to use for SSH";
      };
      public-keys = with types;
        mkOption {
          type = listOf (submodule {
            options = {
              key-file = mkOption {
                type = path;
                description = "Path to public key file.";
              };
              key-id = mkOption {
                type = str;
                description = "ID of key.";
              };
              owner-trust = mkOption {
                type = str;
                description = "Exported owner-trust of key.";
              };
            };
          });
        };
    };
    git = {
      commit-name = mkOption {
        default = null;
        type = with types; nullOr str;
        description = "Git commit name";
      };
      commit-email = mkOption {
        default = null;
        type = with types; nullOr str;
        description = "Git commit email";
      };
    };
    yubikey = {
      u2f-keys = mkOption {
        type = with types; listOf str;
        description = "Yubikey U2F keys";
        default = [ ];
      };
      luks-gpg = {
        public-key-file = mkOption {
          type = with types; nullOr path;
          description = "Public-key for LUKS";
          default = null;
        };
        encrypted-pass-file = mkOption {
          type = with types; nullOr path;
          description = "File containing the encrypted password";
          default = null;
        };
      };

    };
    face-icon = mkOption {
      type = with types; nullOr path;
      description = "Face icon to use";
      default = null;
    };
  };

  config = {
    assertions = [{
      assertion =
        (config.dotfiles.user-settings.yubikey.luks-gpg.public-key-file != null
          && config.dotfiles.user-settings.yubikey.luks-gpg.encrypted-pass-file
          != null)
        || (config.dotfiles.user-settings.yubikey.luks-gpg.public-key-file
          == null
          && config.dotfiles.user-sessings.yubikey.luke-gpg.encrypted-pass-file
          == null);
      message =
        "Either set both dotfiles.user-settings.yubikey.luks-gpg.public-key-file and dotfiles.user-settings.yubikey.luks-gpg.encrypted-pass-file or neither!";
    }];
  };
}


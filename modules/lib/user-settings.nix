{ lib, ... }:
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
    };
  };
}


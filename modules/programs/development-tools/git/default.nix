{ pkgs, lib, config, ... }:
with lib;
let cfg = config.dotfiles.development-tools.git;
in {
  options.dotfiles.development-tools.git = {
    signing = mkOption {
      default = false;
      type = types.bool;
      description = "Enable signing of git commits";
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    {
      home.packages = with pkgs; [ gitAndTools.gh ];
      programs.git = {
        enable = true;
        userName = config.dotfiles.user-settings.git.commit-name;
        userEmail = config.dotfiles.user-settings.git.commit-email;
        lfs.enable = true;
        extraConfig = { pull = { ff = "only"; }; };
      };
    }
    (mkIf cfg.signing {
      programs.git.signing = {
        key = config.dotfiles.user-settings.gpg.git-key;
        signByDefault = true;
      };
    })
  ]);
}


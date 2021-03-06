{ config, lib, ... }:
with lib;
let cfg = config.dotfiles.user-settings;
in
{
  config = {
    assertions = [
      {
        assertion = !config.dotfiles.shell.gpg-agent.enable
          || (config.dotfiles.shell.gpg-agent.enable
          && (length cfg.gpg.ssh-keys) > 0);
        message =
          "GPG-Agent enabled but no SSH keys provided to expose! Please set dotfiles.user-settings.gpg.ssh-keys";
      }
      {
        assertion = !config.dotfiles.development-tools.git.signing
          || (config.dotfiles.development-tools.git.signing && cfg.gpg.git-key
          != null);
        message =
          "Git signing enabled but no key specificed! Please set dotfiles.user-settings.gpg-git-key";
      }
      {
        assertion = !config.dotfiles.development-tools.git.enable
          || (config.dotfiles.development-tools.git.enable
          && cfg.git.commit-name != null);
        message =
          "Git enabled but no name to use for commits provided! Please set dotfiles.user-settings.git.commit-name";
      }
      {
        assertion = !config.dotfiles.development-tools.git.enable
          || (config.dotfiles.development-tools.git.enable
          && cfg.git.commit-email != null);
        message =
          "Git enabled but no email to use for commits provided! Please set dotfiles.user-settings.git.commit-email";
      }
    ];

  };
}

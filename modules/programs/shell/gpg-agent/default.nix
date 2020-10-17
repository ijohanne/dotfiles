{ lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.gpg-agent.enable) {
    services.gpg-agent.enable = true;
  };
}


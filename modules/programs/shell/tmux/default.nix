{ lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.tmux.enable) {
    programs.tmux = {
      enable = true;
      terminal = "tmux-256color";
      shortcut = "a";
      keyMode = "vi";
      secureSocket = false;
      baseIndex = 1;
      extraConfig = builtins.readFile ../../../../configs/tmux/tmux.conf;
    };
  };
}

{ config, lib, ... }:
with lib;
let cfg = config.dotfiles.x11.terminals;
in {
  options.dotfiles.x11.terminals = {
    alacritty = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable alacritty app";
    };
  };

  imports = [ ./alacritty ];

  config = lib.mkIf (cfg.enable) { dotfiles.x11.terminals.alacritty = true; };

}


{ config, lib, ... }:
with lib;
let cfg = config.dotfiles.x11.terminals;
in
{
  options.dotfiles.x11.terminals = {
    alacritty.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable alacritty app";
    };
  };

  imports = [ ./alacritty ];

  config =
    mkIf (cfg.enable) { dotfiles.x11.terminals.alacritty.enable = true; };

}

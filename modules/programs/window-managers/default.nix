{ config, lib, ... }:
with lib;
let cfg = config.dotfiles.window-managers;
in {
  options.dotfiles.window-managers = {
    sway.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable sway window manager";
    };
  };

  imports = [ ./sway ];

  config = mkIf (cfg.enable) { dotfiles.window-managers.sway.enable = true; };

}


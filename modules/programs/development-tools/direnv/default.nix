{ lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.development-tools.direnv.enable) {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableFishIntegration = true;
    };
  };
}

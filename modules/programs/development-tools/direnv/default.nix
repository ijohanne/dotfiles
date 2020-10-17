{ lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.development-tools.direnv.enable) {
    programs.direnv = {
      enable = true;
      enableNixDirenvIntegration = true;
      enableFishIntegration = true;
    };
  };
}


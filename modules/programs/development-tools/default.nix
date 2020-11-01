{ config, lib, ... }:
with lib;
let cfg = config.dotfiles.development-tools;
in {
  options.dotfiles.development-tools = {
    git.enable = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable git app";
    };
    niv.enable = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable niv app";
    };
    lorri.enable = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable lorri app";
    };
    perl.enable = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable perl app";
    };
    neovim.enable = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable neovim app";
    };
    direnv.enable = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable direnv app";
    };
    firefox-addons-generator.enable = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable direnv app";
    };
  };

  imports =
    [ ./git ./niv ./lorri ./perl ./neovim ./direnv ./firefox-addons-generator ];

  config = lib.mkIf (cfg.enable) {
    dotfiles.development-tools.git.enable = true;
    dotfiles.development-tools.niv.enable = true;
    dotfiles.development-tools.lorri.enable = true;
    dotfiles.development-tools.neovim.enable = true;
    dotfiles.development-tools.perl.enable = true;
    dotfiles.development-tools.direnv.enable = true;
    dotfiles.development-tools.firefox-addons-generator.enable = true;
  };

}


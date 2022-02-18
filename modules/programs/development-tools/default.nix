{ config, lib, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools;
in
{
  options.dotfiles.development-tools = {
    git.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable git app";
    };
    niv.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable niv app";
    };
    lorri.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable lorri app";
    };
    perl.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable perl compiler";
    };
    rust.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable rust compiler";
    };
    bash.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable bash tools";
    };
    go.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable go compiler";
    };
    python.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable python compiler";
    };
    html.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable html tools";
    };
    json.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable json tools";
    };
    lua.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable lua compiler";
    };
    dart.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable dart compiler";
    };

    yaml.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable yaml tools";
    };
    tex.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable TeX tools";
    };
    nix.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable nix tools";
    };
    act.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable github actions runner act";
    };
    java.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable java compiler";
    };
    c.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable c compiler";
    };
    vim-language.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable VIM language apps";
    };
    cmake-language.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable CMake language apps";
    };
    docker-language.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable Docker language apps";
    };
    type-script.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable type-script apps";
    };
    neovim.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable neovim app";
    };
    direnv.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable direnv app";
    };
    haskell.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable haskell compiler";
    };
    php.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable php compiler";
    };
  };

  imports =
    [ ./git ./niv ./lorri ./perl ./neovim ./direnv ./rust ./java ./json ./html ./python ./go ./bash ./c ./tex ./lua ./yaml ./nix ./vim-language ./type-script ./docker-language ./cmake-language ./haskell ./dart ./act ./php ];

  config = mkIf (cfg.enable) {
    dotfiles.development-tools.bash.enable = true;
    dotfiles.development-tools.git.enable = true;
    dotfiles.development-tools.niv.enable = true;
    dotfiles.development-tools.lorri.enable = true;
    dotfiles.development-tools.neovim.enable = true;
    dotfiles.development-tools.perl.enable = true;
    dotfiles.development-tools.python.enable = true;
    dotfiles.development-tools.rust.enable = true;
    dotfiles.development-tools.html.enable = true;
    dotfiles.development-tools.go.enable = true;
    dotfiles.development-tools.java.enable = true;
    dotfiles.development-tools.json.enable = true;
    dotfiles.development-tools.c.enable = true;
    dotfiles.development-tools.tex.enable = true;
    dotfiles.development-tools.lua.enable = true;
    dotfiles.development-tools.dart.enable = true;
    dotfiles.development-tools.nix.enable = true;
    dotfiles.development-tools.php.enable = true;
    dotfiles.development-tools.yaml.enable = true;
    dotfiles.development-tools.haskell.enable = true;
    dotfiles.development-tools.direnv.enable = true;
    dotfiles.development-tools.type-script.enable = true;
    dotfiles.development-tools.vim-language.enable = true;
    dotfiles.development-tools.cmake-language.enable = false;
    dotfiles.development-tools.docker-language.enable = true;
  };

}

{ pkgs, config, ... }:

let 
  dots = "${config.home.homeDirectory}/.dotfiles";
in
{
  home.file = {
    ".config/sway/config".source = "${dots}/sway/config";
  };
}

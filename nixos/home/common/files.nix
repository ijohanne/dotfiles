{ config, ... }:
let
  sources = import ../nix;
  pkgs = import sources.nixpkgs { overlays = [ ]; };
  dots = "${config.home.homeDirectory}/.dotfiles";
  vscodeConfigFilePath = if pkgs.stdenv.hostPlatform.isDarwin then
    "Library/Application Support/Code/User/settings.json"
  else
    "${config.xdg.configHome}/Code/User/settings.json";
in {
  home.file = {
    ".config/sway/config".source = "${dots}/sway/config";
    ${vscodeConfigFilePath}.source = "${dots}/vscode/settings.json";
  };
}

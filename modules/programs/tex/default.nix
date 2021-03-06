{ pkgs, lib, config, ... }:
with lib;
let cfg = config.dotfiles.tex;
in
{
  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [ texlive.combined.scheme-full ];
  };
}

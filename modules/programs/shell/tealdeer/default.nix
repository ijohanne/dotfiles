{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.tealdeer.enable) {
    home.packages = with pkgs; [ tealdeer ];
    home.activation.tealdeerCacheScript =
      hm.dag.entryAfter [ "writeBoundary" ] ''
        ${pkgs.tealdeer}/bin/tldr --update
      '';

  };
}

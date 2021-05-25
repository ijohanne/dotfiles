{ pkgs, lib, config, ... }:
with lib;
let
  lastpassCliExportEnv = pkgs.writeShellScriptBin "lastpass-cli-export-env" ''
    ${pkgs.lastpass-cli}/bin/lpass show --notes "$1" | ${pkgs.gawk}/bin/awk '(! /^[ \t]*#/) && (! /^$/) { print "export", $0 }'
  '';
in
{
  config = mkIf (config.dotfiles.shell.lastpass-cli.enable) {
    home.packages = with pkgs; [ lastpass-cli lastpassCliExportEnv ];
  };
}

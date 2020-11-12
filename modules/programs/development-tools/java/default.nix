{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.java;
in
{
  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs; [ openjdk ];
    }
    (mkIf (config.dotfiles.development-tools.neovim.language-servers.enable) {
      home.file."${config.xdg.configHome}/nvim/parser/java.so".source =
        "${pkgs.tree-sitter.builtGrammars.java}/parser";
    })
  ]);
}

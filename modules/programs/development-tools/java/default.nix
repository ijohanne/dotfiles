{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.java;
in
{
  config = mkIf cfg.enable (mkMerge [
    (mkIf config.dotfiles.development-tools.neovim.language-servers.enable {
      home.packages = with pkgs; [ openjdk gradle maven3 ];
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          lspconfig['java_language_server'].setup {
            on_attach = on_attach,
            cmd = {"${pkgs.java-language-server}/bin/java-language-server"}
          }
        '';
      };
      home.file."${config.xdg.configHome}/nvim/parser/java.so".source =
        "${pkgs.tree-sitter.builtGrammars.tree-sitter-java}/parser";
    })
  ]);
}

{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.dart;
in
{
  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs; [ dart ];
    }
    (mkIf (config.dotfiles.development-tools.neovim.language-servers.enable) {
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          lspconfig['dartls'].setup {
            on_attach = on_attach,
          }
        '';
      };
      home.file."${config.xdg.configHome}/nvim/parser/dart.so".source =
        "${pkgs.tree-sitter.builtGrammars.tree-sitter-dart}/parser";
    })
  ]);
}

{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.go;
in
{
  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs; [ go ];
    }
    (mkIf config.dotfiles.development-tools.neovim.language-servers.enable {
      home.packages = with pkgs; [ gopls ];
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          lspconfig['gopls'].setup {
            on_attach = on_attach,
            cmd = {"${pkgs.gopls}/bin/gopls"}
          }
        '';
      };
      home.file."${config.xdg.configHome}/nvim/parser/go.so".source =
        "${pkgs.tree-sitter.builtGrammars.tree-sitter-go}/parser";
    })
  ]);
}

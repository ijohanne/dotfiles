{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.html;
in
{
  config = mkIf cfg.enable (mkMerge [
    (mkIf config.dotfiles.development-tools.neovim.language-servers.enable {
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          lspconfig['html'].setup {
            on_attach = on_attach,
            cmd = {"${pkgs.nodePackages.vscode-html-languageserver-bin}/bin/html-languageserver", "--stdio" }
          }
          lspconfig['cssls'].setup {
            on_attach = on_attach,
            cmd = {"${pkgs.nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver", "--stdio"}
          }
        '';
      };
      home.file."${config.xdg.configHome}/nvim/parser/html.so".source =
        "${pkgs.tree-sitter.builtGrammars.tree-sitter-html}/parser";
    })
  ]);
}

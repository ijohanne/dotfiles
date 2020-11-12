{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.json;
in
{
  config = mkIf cfg.enable (mkMerge [
    (mkIf config.dotfiles.development-tools.neovim.language-servers.enable {
      home.packages = with pkgs; [ nodePackages.vscode-html-languageserver-bin ];
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          nvim_lsp['jsonls'].setup {
            on_attach = on_attach,
            cmd = {"${pkgs.nodePackages.vscode-json-languageserver-bin}/bin/json-languageserver"}
          }
        '';
      };
    })
  ]);
}

{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.json;
in
{
  config = mkIf cfg.enable (mkMerge [
    (mkIf config.dotfiles.development-tools.neovim.language-servers.enable {
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          lspconfig['jsonls'].setup {
            on_attach = on_attach,
            cmd = {"${pkgs.nodePackages.vscode-json-languageserver-bin}/bin/json-languageserver", "--stdio" },
            capabilities = capabilities
          }
        '';
      };
    })
  ]);
}

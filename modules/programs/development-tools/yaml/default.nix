{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.yaml;
in
{
  config = mkIf cfg.enable (mkMerge [
    (mkIf (config.dotfiles.development-tools.neovim.language-servers.enable) {
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          lspconfig['yamlls'].setup {
            on_attach = on_attach,
            capabilities = capabilities,
            cmd = {"${pkgs.yaml-language-server}/bin/yaml-language-server"}
          }
        '';
      };
    })
  ]);
}

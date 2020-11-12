{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.yaml;
in
{
  config = mkIf cfg.enable (mkMerge [
    (mkIf (config.dotfiles.development-tools.neovim.language-servers.enable) {
      home.packages = with pkgs; [ yaml-language-server ];
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          nvim_lsp['yamlls'].setup {
            on_attach = on_attach,
            cmd = {"${pkgs.yaml-language-server}/bin/yamlls"}
          }
        '';
      };
    })
  ]);
}

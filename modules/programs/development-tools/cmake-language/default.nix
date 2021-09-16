{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.cmake-language;
  language-server = pkgs.cmake-language-server.overrideAttrs (_: {
    doInstallCheck = false;
  });
in
{
  config = mkIf cfg.enable (mkMerge [
    (mkIf config.dotfiles.development-tools.neovim.language-servers.enable {
      home.packages = with pkgs; [ language-server cmake ];
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          lspconfig['cmake'].setup {
            on_attach = on_attach,
            cmd = {"${language-server}/bin/cmake-language-server"}
          }
        '';
      };
    })
  ]);
}

{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.docker-language;
in
{
  config = mkIf cfg.enable (mkMerge [
    (mkIf config.dotfiles.development-tools.neovim.language-servers.enable {
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          local util = require 'lspconfig/util'
          lspconfig['dockerls'].setup {
            on_attach = on_attach,
            cmd = {"${pkgs.nodePackages.dockerfile-language-server-nodejs}/bin/docker-langserver", "--stdio"},
            root_dir = util.path.dirname
          }
        '';
      };
    })
  ]);
}

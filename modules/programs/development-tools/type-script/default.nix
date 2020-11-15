{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.type-script;
in
{
  config = mkIf cfg.enable (mkMerge [
    (mkIf config.dotfiles.development-tools.neovim.language-servers.enable {
      home.packages = with pkgs; [ nodePackages.typescript-language-server ];
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          lspconfig['tsserver'].setup {
            on_attach = on_attach,
            cmd = {"${pkgs.nodePackages.typescript-language-server}/bin/tsserver", "--stdio"}
          }
        '';
      };
    })
  ]);
}

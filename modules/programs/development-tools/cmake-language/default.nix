{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.cmake-language;
in
{
  config = mkIf cfg.enable (mkMerge [
    (mkIf config.dotfiles.development-tools.neovim.language-servers.enable {
      home.packages = with pkgs; [ nodePackages.bash-language-server bash ];
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          nvim_lsp['cmake'].setup {
            on_attach = on_attach,
            cmd = {"${pkgs.cmake-language-server}/bin/cmake-language-server"}
          }
        '';
      };
    })
  ]);
}

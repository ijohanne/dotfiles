{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.vim-language;
in
{
  config = mkIf cfg.enable (mkMerge [
    (mkIf config.dotfiles.development-tools.neovim.language-servers.enable {
      home.packages = with pkgs; [ nodePackages.vim-language-server ];
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          nvim_lsp['vimls'].setup {
            on_attach = on_attach,
            cmd = {"${pkgs.nodePackages.vim-language-server}/bin/vim-language-server", "--stdio"}
          }
        '';
      };
    })
  ]);
}

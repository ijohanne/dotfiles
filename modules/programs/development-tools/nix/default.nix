{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.nix;
in
{
  config = mkIf cfg.enable (mkMerge [
    (mkIf config.dotfiles.development-tools.neovim.language-servers.enable {
      home.packages = with pkgs; [ rnix-lsp ];
      dotfiles.development-tools.neovim.language-servers = {
        #extraLua = ''
        #  lspconfig['rnix'].setup {
        #    on_attach = on_attach,
        #    cmd = {"${pkgs.rnix-lsp}/bin/rnix-lsp"},
        #    filetypes = {"nix"}
        #  }
        #'';
      };
    })
  ]);
}

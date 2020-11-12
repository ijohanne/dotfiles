{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.tex;
in
{
  config = mkIf cfg.enable (mkMerge [
    (mkIf (config.dotfiles.development-tools.neovim.language-servers.enable) {
      home.packages = with pkgs; [ texlab ];
      programs.neovim.plugins = with pkgs.vimPlugins; [ vimtex ];
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          nvim_lsp['texlab'].setup {
            on_attach = on_attach,
            cmd = {"${pkgs.texlab}/bin/texlab"}
          }
        '';
      };
    })
  ]);
}

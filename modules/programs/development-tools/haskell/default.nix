{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.haskell;
in
{
  config = mkIf (pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64 && cfg.enable) (mkMerge [
    {
      home.packages = with pkgs; [ haskell.compiler.ghc8102 ] ++ (with pkgs.haskellPackages; [ cabal-install stack ]);
    }
    (mkIf config.dotfiles.development-tools.neovim.language-servers.enable
      {
        home.packages = [ pkgs.haskell-language-server ];
        dotfiles.development-tools.neovim.language-servers = {
          extraLua = ''
            lspconfig['hls'].setup {
              on_attach = on_attach,
              cmd = {"${pkgs.haskell-language-server}/bin/haskell-language-server-8.10.2", "--lsp" }
            }
          '';
        };
      }
    )
  ]);
}

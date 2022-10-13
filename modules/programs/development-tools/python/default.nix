{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.python;
in
{
  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs; [ python3Minimal ];
    }
    (mkIf (config.dotfiles.development-tools.neovim.language-servers.enable && pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64)
      {
        home.packages = with pkgs; [ python3Packages.python-lsp-server ];
        dotfiles.development-tools.neovim.language-servers = {
          extraLua = ''
            lspconfig['pylsp'].setup {
              on_attach = on_attach,
              cmd = {"${pkgs.python3Packages.python-lsp-server}/bin/pylsp"},
              capabilities = capabilities
            }
          '';
        };
        home.file."${config.xdg.configHome}/nvim/parser/python.so".source =
          "${pkgs.tree-sitter.builtGrammars.tree-sitter-python}/parser";
      })
  ]);
}

{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.bash;
in
{
  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs; [ bash ];
    }
    (mkIf config.dotfiles.development-tools.neovim.language-servers.enable {
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          lspconfig['bashls'].setup {
            on_attach = on_attach,
            cmd = {"${pkgs.nodePackages.bash-language-server}/bin/bash-language-server"},
            capabilities = capabilities
          }
        '';
      };
      home.file."${config.xdg.configHome}/nvim/parser/bash.so".source =
        "${pkgs.tree-sitter.builtGrammars.tree-sitter-bash}/parser";
    })
  ]);
}

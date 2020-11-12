{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.bash;
in
{
  config = mkIf cfg.enable (mkMerge [
    (mkIf config.dotfiles.development-tools.neovim.language-servers.enable {
      home.packages = with pkgs; [ nodePackages.bash-language-server bash ];
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          nvim_lsp['bashls'].setup {
            on_attach = on_attach,
            cmd = {"${pkgs.nodePackages.bash-language-server}/bin/bash-language-server"}
          }
        '';
      };
      home.file."${config.xdg.configHome}/nvim/parser/bash.so".source =
        "${pkgs.tree-sitter.builtGrammars.bash}/parser";
    })
  ]);
}

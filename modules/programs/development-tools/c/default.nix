{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.c;
in
{
  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs; [ clang-tools ];
    }
    (mkIf config.dotfiles.development-tools.neovim.language-servers.enable {
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          nvim_lsp['clangd'].setup {
            on_attach = on_attach,
            cmd = {"${pkgs.clang-tools}/bin/clangd", "--background-index"};
          }
        '';
      };
      home.file."${config.xdg.configHome}/nvim/parser/c.so".source =
        "${pkgs.tree-sitter.builtGrammars.c}/parser";
      home.file."${config.xdg.configHome}/nvim/parser/cpp.so".source =
        "${pkgs.tree-sitter.builtGrammars.cpp}/parser";
    })
  ]);
}

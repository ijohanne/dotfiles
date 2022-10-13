{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.lua;
in
{
  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs; [ lua ];
    }
    (mkIf (config.dotfiles.development-tools.neovim.language-servers.enable) {
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          lspconfig['sumneko_lua'].setup {
            on_attach = on_attach,
            cmd = {"${pkgs.lua-language-server}/bin/lua-language-server"},
            capabilities = capabilities
          }
        '';
      };
      home.file."${config.xdg.configHome}/nvim/parser/lua.so".source =
        "${pkgs.tree-sitter.builtGrammars.tree-sitter-lua}/parser";
    })
  ]);
}

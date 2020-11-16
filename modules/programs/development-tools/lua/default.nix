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
      home.packages = with pkgs; [ nur-ijohanne.lua-language-server ];
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          lspconfig['sumneko_lua'].setup {
            on_attach = on_attach,
            cmd = {"${pkgs.nur-ijohanne.lua-language-server}/bin/lua-language-server"}
          }
        '';
      };
      home.file."${config.xdg.configHome}/nvim/parser/lua.so".source =
        "${pkgs.tree-sitter.builtGrammars.lua}/parser";
    })
  ]);
}

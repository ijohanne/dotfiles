{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.php;
in
{
  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs.php-packages; [ pkgs.php composer2nix ];
    }
    (mkIf config.dotfiles.development-tools.neovim.language-servers.enable {
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          lspconfig['phpactor'].setup {
            on_attach = on_attach,
            cmd = {"${pkgs.php-packages.phpactor}/bin/phpactor", "language-server"}
          }
        '';
      };
      home.file."${config.xdg.configHome}/nvim/parser/php.so".source =
        "${pkgs.tree-sitter.builtGrammars.tree-sitter-php}/parser";
    })
  ]);
}

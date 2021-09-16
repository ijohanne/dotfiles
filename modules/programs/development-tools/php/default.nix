{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.php;
in
{
  config = mkIf cfg.enable (mkMerge [
    (mkIf config.dotfiles.development-tools.neovim.language-servers.enable {
      home.packages = with pkgs.php-packages; [ phpactor composer2nix ];
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

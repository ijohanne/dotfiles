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
    (mkIf (config.dotfiles.development-tools.neovim.language-servers.enable && pkgs.stdenv.isLinux && pkgs.stdenv.hostPlatform.platform.kernelArch == "x86_64") {
      home.packages = with pkgs; [ python-language-server ];
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          nvim_lsp['pyls_ms'].setup {
            on_attach = on_attach,
            cmd = {"${pkgs.python-language-server}/bin/python-language-server"}
          }
        '';
      };
      home.file."${config.xdg.configHome}/nvim/parser/python.so".source =
        "${pkgs.tree-sitter.builtGrammars.python}/parser";
    })
  ]);
}

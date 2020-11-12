{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.rust;
in
{
  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs.rustPackages; [ rustc cargo clippy rustfmt ];
    }
    (mkIf config.dotfiles.development-tools.neovim.language-servers.enable {
      home.packages = [ pkgs.rust-analyzer ];
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          nvim_lsp['rust_analyzer'].setup {
            on_attach = on_attach,
            cmd = {"${pkgs.rust-analyzer}/bin/rust-analyzer"}
          }
        '';
        extraNvim = ''
          " Inlay hints for Rust
          autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs :lua require'lsp_extensions'.inlay_hints{ prefix = ' » ', highlight = "NonText" }
        '';
      };
    })
  ]);
}

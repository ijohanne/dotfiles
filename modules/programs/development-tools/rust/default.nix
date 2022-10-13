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
      home.packages = with pkgs; [ lldb_13 ];
      programs.neovim.plugins = with pkgs.vimPlugins; [ rust-tools-nvim ];
      dotfiles.development-tools.neovim.language-servers = {
        extraLua = ''
          local codelldb_path = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb"
          local liblldb_path = "${pkgs.lldb_13.lib}/lib/liblldb.so.13"
          local opts = {
            server = {
              on_attach = on_attach,
              capabilities = capabilities,
              cmd = {"${pkgs.rust-analyzer}/bin/rust-analyzer"},
              settings = {
                ["rust-analyzer"] = {
                  assist = {
                    importMergeBehavior = "last",
                    importPrefix = "by_self",
                  },
                  diagnostics = {
                    disabled = { "unresolved-import" }
                  },
                  cargo = {
                      loadOutDirsFromCheck = true
                  },
                  procMacro = {
                      enable = true
                  },
                  checkOnSave = {
                      command = "clippy"
                  },
                }
              }
            },
            dap = {
              adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
            }
          }
          require('rust-tools').setup(opts)
        '';
        extraNvim = ''
          " FIXME: Borked right now
          " Inlay hints for Rust
          " autocmd BufEnter,TabEnter,BufWinEnter *.rs :lua require'lsp_extensions'.inlay_hints{ prefix = ' » ', highlight = "NonText" }
        '';
      };
      home.file."${config.xdg.configHome}/nvim/parser/rust.so".source =
        "${pkgs.tree-sitter.builtGrammars.tree-sitter-rust}/parser";
    })
  ]);
}

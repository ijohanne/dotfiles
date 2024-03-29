{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.neovim;
in
{
  options.dotfiles.development-tools.neovim = {
    language-servers = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "Enable language servers";
      };
      extraLua = mkOption {
        default = "";
        type = types.lines;
        description = "Extra Lua scripting for LSPs";
      };
      extraNvim = mkOption {
        default = "";
        type = types.lines;
        description = "Extra Nvim settings for LSPs";
      };
    };

    language-tool.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable language tool";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs; [ clang_10 hexokinase ];
      programs.fish.shellAliases = {
        "vim" = "nvim";
        "vi" = "nvim";
        "vimdiff" = "nvim -d";
      };
      programs.git.ignores =
        pkgs.lib.global_git_ignore_list "/Global/Vim.gitignore"
        ++ pkgs.lib.global_git_ignore_list "/Global/Tags.gitignore" ++ [
          ''
            # Neovim log files
            .nvimlog
          ''
        ];
      programs.neovim = {
        enable = true;
        withNodeJs = true;
        withPython3 = true;

        package = pkgs.neovim-nightly;
        extraConfig = builtins.readFile ../../../../configs/neovim/init.vim;
        plugins = with pkgs.vimPlugins; [
          barbar-nvim
          ctrlp-vim
          direnv-vim
          fzf-vim
          fzfWrapper
          indentLine
          nvim-treesitter
          nvim-web-devicons
          onedark-vim
          splitjoin-vim
          vim-commentary
          vim-crates
          vim-devicons
          vim-dirvish
          vim-dispatch
          vim-easy-align
          vim-eunuch
          vim-fugitive
          vim-gitgutter
          vim-polyglot
          vim-repeat
          vim-rhubarb
          vim-sensible
          vim-sleuth
          vim-slime
          vim-surround
          vim-tmux-navigator
          vim-trailing-whitespace
          vim-unimpaired
          vim-vinegar
          bubbly-nvim
          vim-signify
          edge
          # Disabled for now, plugin is buggy on NixOS
          # vim-hexokinase
        ];
      };
      home.sessionVariables = { EDITOR = "${pkgs.neovim-nightly}/bin/nvim"; };
    }
    (mkIf cfg.language-servers.enable {
      home.packages = with pkgs;
        [
          ctags
          neovim-remote
        ];
      programs.neovim = {
        extraConfig = builtins.readFile ../../../../configs/neovim/lsp.vim + ''
          lua <<EOF
          local lspconfig = require 'lspconfig'

          require("dapui").setup()

          vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

          ${cfg.language-servers.extraLua}

          EOF
          ${cfg.language-servers.extraNvim}
          let g:gutentags_file_list_command = {
            \ 'markers': {
              \ '.git': 'git ls-files',
              \ '.hg': 'hg files',
            \ },
          \ }

          nnoremap <silent> <F6>    <cmd>lua require'dapui'.toggle()<CR>
          nnoremap <silent> <F7>    <cmd>lua require'dap'.toggle_breakpoint()<CR>
          nnoremap <silent> <F8>    <cmd>lua require('dapui').eval()<CR>
          nnoremap <silent> <F9>    <cmd>lua require'dap'.continue()<CR>
          nnoremap <silent> g<F9>   <cmd>lua require'dap'.run_to_cursor()<CR>
          nnoremap <silent> <F10>   <cmd>lua require'dap'.step_over()<CR>
          nnoremap <silent> <F11>   <cmd>lua require'dap'.step_into()<CR>
          nnoremap <silent> <F12>   <cmd>lua require'dap'.step_out()<CR>

          command! CodeActionMenu lua require('code_action_menu').open_code_action_menu()
        '';
        plugins = with pkgs.vimPlugins; [
          # For now override until it's merged in upstream
          nvim-cmp
          cmp-nvim-lsp
          cmp-git
          cmp-buffer
          cmp-path
          cmp-cmdline
          cmp-vsnip
          vim-vsnip
          neoformat
          nvim-lsp-extensions
          nvim-lspconfig
          vim-gutentags
          nvim-luadev
          nvim-luapad
          nvim-dap
          plenary-nvim
          telescope-nvim
          nvim-dap-ui
          nvim-code-action-menu
          nvim-lightbulb
        ];
      };
    })
    (mkIf cfg.language-tool.enable {
      home.packages = with pkgs; [
        languagetool
        (hunspellWithDicts config.dotfiles.user-settings.dictionaries)
      ];
      programs.neovim = {
        extraConfig =
          "let g:languagetool_server_command='${pkgs.languagetool}/bin/languagetool-http-server'";
        plugins = with pkgs.vimPlugins; [ language-tool-nvim ];
      };
    })
  ]);
}

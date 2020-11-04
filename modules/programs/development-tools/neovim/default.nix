{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.neovim;
  vimPlugins = pkgs.callPackage ./vim-plugins.nix { } // pkgs.vimPlugins;
  dotfilesLib = pkgs.callPackage ../../lib.nix { };
in {
  options.dotfiles.development-tools.neovim = {
    language-servers.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable language servers";
    };
    language-tool.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable language tool";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.fish.shellAliases = {
        "vim" = "nvim";
        "vi" = "nvim";
        "vimdiff" = "nvim -d";
      };
      programs.git.ignores =
        dotfilesLib.global_git_ignore_list "/Global/Vim.gitignore"
        ++ dotfilesLib.global_git_ignore_list "/Global/Tags.gitignore" ++ [''
          # Neovim log files
          .nvimlog
        ''];
      programs.neovim = {
        enable = true;
        withNodeJs = true;
        withPython3 = true;

        package = pkgs.neovim-nightly;
        extraConfig = builtins.readFile ../../../../configs/neovim/init.vim;
        plugins = with vimPlugins; [
          fzf-vim
          fzfWrapper
          indentLine
          lightline-vim
          onedark-vim
          splitjoin-vim
          vim-commentary
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
          vim-unimpaired
          vim-vinegar
          vimtex
          direnv-vim
          nerdtree
          vim-nerdtree-tabs
          vim-nerdtree-syntax-highlight
          vim-devicons
          ctrlp-vim
        ];
      };
      home.sessionVariables = { EDITOR = "${pkgs.neovim-nightly}/bin/nvim"; };
    }
    (mkIf cfg.language-servers.enable {
      home.packages = with pkgs;
        with stdenv.lib;
        [ rnix-lsp neovim-remote lua ctags rust-analyzer ]
        ++ (with pkgs.nodePackages; [
          typescript-language-server
          vim-language-server
          vscode-json-languageserver-bin
          vscode-html-languageserver-bin
        ]) ++ optionals
        (stdenv.isLinux && stdenv.hostPlatform.platform.kernelArch == "x86_64")
        [ python-language-server ];
      programs.neovim = {
        extraConfig = builtins.readFile ../../../../configs/neovim/lsp.vim;
        plugins = with vimPlugins; [
          vim-gutentags
          completion-nvim
          diagnostic-nvim
          nvim-lsp-extensions
          neoformat
          nvim-lspconfig-git
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
        plugins = with vimPlugins; [ Language-tool-nvim-git ];
      };
    })
  ]);
}


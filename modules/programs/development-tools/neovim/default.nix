{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.dotfiles.development-tools.neovim;
  vimPlugins = pkgs.vimPlugins // pkgs.callPackage ./vim-plugins.nix { };
  dotfilesLib = pkgs.callPackage ../../lib.nix { };
in
{
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
        ++ dotfilesLib.global_git_ignore_list "/Global/Tags.gitignore" ++ [
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
        plugins = with vimPlugins; [
          barbar-nvim
          ctrlp-vim
          direnv-vim
          fzf-vim
          fzfWrapper
          indentLine
          lightline-vim
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
          vimtex
        ];
      };
      home.sessionVariables = { EDITOR = "${pkgs.neovim-nightly}/bin/nvim"; };
      home.file."${config.xdg.configHome}/nvim/parser/c.so".source =
        "${pkgs.tree-sitter.builtGrammars.c}/parser";
      home.file."${config.xdg.configHome}/nvim/parser/bash.so".source =
        "${pkgs.tree-sitter.builtGrammars.bash}/parser";
      home.file."${config.xdg.configHome}/nvim/parser/lua.so".source =
        "${pkgs.tree-sitter.builtGrammars.lua}/parser";
      home.file."${config.xdg.configHome}/nvim/parser/python.so".source =
        "${pkgs.tree-sitter.builtGrammars.python}/parser";
      home.file."${config.xdg.configHome}/nvim/parser/go.so".source =
        "${pkgs.tree-sitter.builtGrammars.go}/parser";
      home.file."${config.xdg.configHome}/nvim/parser/cpp.so".source =
        "${pkgs.tree-sitter.builtGrammars.cpp}/parser";
      home.file."${config.xdg.configHome}/nvim/parser/json.so".source =
        "${pkgs.tree-sitter.builtGrammars.json}/parser";
      home.file."${config.xdg.configHome}/nvim/parser/ruby.so".source =
        "${pkgs.tree-sitter.builtGrammars.ruby}/parser";
    }
    (mkIf cfg.language-servers.enable {
      home.packages = with pkgs;
        with stdenv.lib;
        [
          ctags
          go
          gopls
          lua
          neovim-remote
          rnix-lsp
          rust-analyzer
          yaml-language-server
        ] ++ (with pkgs.nodePackages; [
          texlab
          typescript-language-server
          vim-language-server
          vscode-html-languageserver-bin
          vscode-json-languageserver-bin
        ]) ++ optionals
          (stdenv.isLinux && stdenv.hostPlatform.platform.kernelArch == "x86_64")
          [ python-language-server ];
      programs.neovim = {
        extraConfig = builtins.readFile ../../../../configs/neovim/lsp.vim;
        plugins = with vimPlugins; [
          completion-nvim
          diagnostic-nvim
          neoformat
          nvim-lsp-extensions
          nvim-lspconfig
          vim-gutentags
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
        plugins = with vimPlugins; [ Language-tool-nvim ];
      };
    })
  ]);
}

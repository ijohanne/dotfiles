{ pkgs, ... }:
let
  sources = import ../../../../nix/sources.nix;
  vimPlugins = pkgs.callPackage ./vim-plugins.nix { } // pkgs.vimPlugins;
in {

  home.packages = with pkgs;
    with stdenv.lib;
    [ rnix-lsp neovim-remote lua zoxide fzf ctags rust-analyzer bat fd ]
    ++ (with pkgs.nodePackages; [
      typescript-language-server
      vim-language-server
      vscode-json-languageserver-bin
      vscode-html-languageserver-bin
    ]) ++ optionals
    (stdenv.isLinux && stdenv.hostPlatform.platform.kernelArch == "x86_64")
    [ python-language-server ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    package = pkgs.neovim-nightly;
    extraConfig = builtins.readFile ../../../../configs/neovim/init.vim;
    plugins = with vimPlugins; [
      completion-nvim
      diagnostic-nvim
      fzf-vim
      fzfWrapper
      indentLine
      lightline-vim
      neoformat
      nvim-lspconfig
      onedark-vim
      splitjoin-vim
      vim-commentary
      vim-dirvish
      vim-dispatch
      vim-easy-align
      vim-eunuch
      vim-fugitive
      vim-gitgutter
      vim-gutentags
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
      nvim-lsp-extensions
    ];
  };

  home.sessionVariables = { EDITOR = "${pkgs.neovim-nightly}"; };
}

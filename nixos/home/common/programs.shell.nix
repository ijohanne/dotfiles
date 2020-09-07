let
  sources = import ../nix;
  pkgs = import sources.nixpkgs {
    overlays = [ sources.neovim-overlay sources.mozilla-overlay ];
  };
  vimPlugins = pkgs.callPackage ./vim-plugins.nix { } // pkgs.vimPlugins;
in {
  home.packages = with pkgs;
    with stdenv.lib;
    [
      rnix-lsp
      neovim-remote
      lua
      ctags
      nodePackages.vim-language-server
      rust-analyzer
    ] ++ optionals
    (stdenv.isLinux && stdenv.hostPlatform.platform.kernelArch == "x86_64")
    [ python-language-server ];

  programs.git = {
    enable = true;
    userName = "Ian Johannesen";
    userEmail = "ij@opsplaza.com";
    lfs.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.htop = {
    enable = true;
    treeView = true;
    showThreadNames = true;
    detailedCpuTime = true;
    cpuCountFromZero = true;
  };

  programs.zsh = {
    enable = true;
    history.extended = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      theme = "rkj-repos";
    };
    initExtra = ''
      source $HOME/.dotfiles/zsh/common-local.zsh
    '';
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    package = pkgs.neovim-nightly;
    extraConfig = builtins.readFile ../../../neovim/init.vim;
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
    ];
  };

}

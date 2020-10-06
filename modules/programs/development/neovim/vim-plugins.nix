{ pkgs }: {
  vim-nerdtree-syntax-highlight = pkgs.vimUtils.buildVimPlugin {
    name = "vim-nerdtree-syntax-highlight";
    src = pkgs.fetchFromGitHub {
      owner = "tiagofumo";
      repo = "vim-nerdtree-syntax-highlight";
      rev = "1acc12aa7f773ede38538293332905f1ba3fea6a";
      sha256 = "0zm023mhi1si9g5r46md1v4rlls6z2m6kyn1jcfxjqyrgba67899";
    };
  };
  nvim-lsp-extensions = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-lsp-extensions";
    src = pkgs.fetchFromGitHub {
      owner = "tjdevries";
      repo = "lsp_extensions.nvim";
      rev = "7c3f907c3cf94d5797dcdaf5a72c5364a91e6bd2";
      sha256 = "0c9glx0hn28m5jzz52ny1rcp63s9fdlznvywy4gzwwqi9rscqznz";
    };
  };
}


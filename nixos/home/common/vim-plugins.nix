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

}


{ pkgs, ... }:

{

  programs.vim = {
    enable = true;
    plugins = [
    "sensible"
    "colors-solarized"
    "fugitive"
    ];
    settings = {
      ignorecase = true;
      expandtab = true;
      history = 1000;
      tabstop = 4;
    };
    extraConfig = ''
    set cuc cul        " Crosshair
    set cc=80          " 80 column lines
    set linebreak      " Break lines at word (requires Wrap lines)
    set textwidth=80   " Line wrap (number of cols)
    set showmatch      " Highlight matching brace
    set visualbell     " Use visual bell (no beeping)
    set hlsearch       " Highlight all search results
    set smartcase      " Enable smart-case search
    set shiftwidth=4   " Number of auto-indent spaces
    set smartindent    " Enable smart-indent
    imap fd <Esc>
    set mouse=a
    ""
    "" Auto-switch theme
    let hour = strftime("%H")
    if 6 <= hour && hour < 18
      set background=light
    else
      set background=dark
    endif
    let g:solarized_termcolors=256
    colorscheme solarized
  '';
  };

  programs.git = {
    enable = true;
    userName = "Ian Johannesen";
    userEmail = "ij@concordium.com";
    lfs.enable = true;
  };

  programs.direnv.enable = true;
  programs.htop.enable = true;
  programs.vscode = {
    enable = true;
    extensions = [
      pkgs.vscode-extensions.bbenoist.Nix
    ];
    userSettings = {
      "editor.fontFamily" = "'Inconsolata'";
    };
  };
  
  programs.zsh = {
    enable = true;
    history.extended = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "zsh_reload" "kubectl" "ssh-agent" ];
      theme = "rkj-repos";
    };
    initExtra = ''
      source $HOME/.dotfiles/zsh/common-local.zsh
    '';
  };

  programs.firefox = {
    enable = true;
    enableIcedTea = true;
  };

  programs.home-manager = {
    enable = true;
    path = "..";
  };
}

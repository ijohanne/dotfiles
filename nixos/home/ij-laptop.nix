{ pkgs, ... }:

let 
  user_realname = "Ian Johannesen";
  user_email = "ij@concordium.com";
  dotfiles = "/home/ij/.dotfiles";
in
{
  nixpkgs.overlays = [ (import ./overlays/package-upgrades) ];

  home.packages = with pkgs; [
    htop
    slack
    riot-desktop
    kubectl
    rustup
    thunderbird
    llvm 
    libreoffice
    spotify
    llvm
    clang
    stack
  ];

  fonts.fontconfig.enable = true;
    gtk = {
      enable = true;
      font = {
        name = "DejaVu Sans 10";
        package = pkgs.dejavu_fonts;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.gnome3.adwaita-icon-theme;
      };
      theme = {
        name = "Equilux";
        package = pkgs.equilux-theme;
      };
  };

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

  programs.gnome-terminal = {
    enable = true;
    showMenubar = false;
    profile = {
      "5ddfe964-7ee6-4131-b449-26bdd97518f7" = {
        default = true;
        visibleName = "Tomorrow Night";
        cursorShape = "ibeam";
        font = "DejaVu Sans Mono 8";
        showScrollbar = false;
        colors = {
          foregroundColor = "rgb(197,200,198)";
          palette = [
            "rgb(0,0,0)" "rgb(145,34,38)"
            "rgb(119,137,0)" "rgb(174,123,0)"
            "rgb(103,123,192)" "rgb(104,42,155)"
            "rgb(43,102,81)" "rgb(146,149,147)"
            "rgb(102,102,102)" "rgb(204,102,102)"
            "rgb(181,189,104)" "rgb(240,198,116)"
            "rgb(140,152,191)" "rgb(178,148,187)"
            "rgb(138,190,183)" "rgb(236,235,236)"
          ];
          boldColor = "rgb(138,186,183)";
          backgroundColor = "rgb(29,31,33)";
        };
      };
    };
  }; 


  programs.git = {
    enable = true;
    userName = "${user_realname}";
    userEmail = "${user_email}";
    lfs.enable = true;
  };

  programs.direnv.enable = true;
  programs.htop.enable = true;
  programs.vscode.enable = true;

  programs.zsh = {
    enable = true;
    history.extended = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "zsh_reload" "kubectl" ];
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

  services.gnome-keyring.enable = true;
  services.gpg-agent.enable = true;
  services.network-manager-applet.enable = true;
  #services.blueman-applet.enable = true;

  home.file = {
  };
}

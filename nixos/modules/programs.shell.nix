{ pkgs, ... }:
let
  sources = import ../nix/sources.nix;
  vimPlugins = pkgs.callPackage ./vim-plugins.nix { } // pkgs.vimPlugins;
  fishPlugins = pkgs.callPackage ./fish-plugins.nix { };
in {

  programs = {
    home-manager = {
      enable = true;
      path = "${sources.home-manager}";
    };
  };

  home.packages = with pkgs;
    with stdenv.lib;
    [ rnix-lsp neovim-remote lua zoxide fzf ctags rust-analyzer ]
    ++ (with pkgs.nodePackages; [
      typescript-language-server
      vim-language-server
      vscode-json-languageserver-bin
      vscode-html-languageserver-bin
    ]) ++ optionals
    (stdenv.isLinux && stdenv.hostPlatform.platform.kernelArch == "x86_64")
    [ python-language-server ];

  programs.git = {
    enable = true;
    userName = "Ian Johannesen";
    userEmail = "ij@opsplaza.com";
    lfs.enable = true;
    extraConfig = { pull = { ff = "only"; }; };
  };

  programs.htop = {
    enable = true;
    treeView = true;
    showThreadNames = true;
    detailedCpuTime = true;
    cpuCountFromZero = true;
  };

  programs.starship = {
    enableFishIntegration = true;
    enable = true;
    settings = {
      add_newline = false;
      prompt_order = [
        "username"
        "hostname"
        "kubernetes"
        "directory"
        "git_branch"
        "git_commit"
        "git_state"
        "git_status"
        "hg_branch"
        "docker_context"
        "package"
        "dotnet"
        "elixir"
        "elm"
        "erlang"
        "golang"
        "java"
        "julia"
        "nim"
        "nodejs"
        "ocaml"
        "php"
        "purescript"
        "python"
        "ruby"
        "rust"
        "terraform"
        "zig"
        "nix_shell"
        "conda"
        "memory_usage"
        "aws"
        "env_var"
        "crystal"
        "cmd_duration"
        "custom"
        "line_break"
        "jobs"
        "battery"
        "time"
        "character"
      ];
      scan_timeout = 10;
      character.symbol = "➜";
      battery = {
        full_symbol = "🔋";
        charging_symbol = "⚡️";
        discharging_symbol = "🔋";
        display = [
          {
            threshold = 10;
            style = "red";
          }
          {
            threshold = 30;
            style = "yellow";
          }
          {
            threshold = 100;
            style = "green";
          }
        ];
      };

      username = {
        show_always = true;
        style_user = "blue";
      };

      hostname = {
        ssh_only = false;
        style = "cyan";
        prefix = "⟪";
        suffix = "⟫";
      };
    };
  };

  programs.fish = {
    enable = true;
    shellInit = builtins.readFile ../../configs/fish/init.fish;
    plugins = with fishPlugins; [
      bass
      oh-my-fish-plugin-ssh
      oh-my-fish-plugin-foreign-env
      fish-ssh-agent
    ];
  };

  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    package = pkgs.neovim-nightly;
    extraConfig = builtins.readFile ../../configs/neovim/init.vim;
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

}

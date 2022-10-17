{
  imports = [ ../programs ];
  dotfiles.shell.enable = true;
  dotfiles.development-tools.enable = true;
  dotfiles.development-tools.git.signing = true;
  home.username = "ij";
  home.homeDirectory = "/home/ij";
  home.stateVersion = "22.05";
}

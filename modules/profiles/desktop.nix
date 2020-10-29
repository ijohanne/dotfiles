{
  imports = [ ../programs ];
  dotfiles.x11.communications.enable = true;
  dotfiles.x11.media.enable = true;
  dotfiles.x11.office.enable = true;
  dotfiles.x11.terminals.enable = true;
  dotfiles.shell.enable = true;
  dotfiles.tex.enable = true;
  dotfiles.browsers.enable = true;
  dotfiles.development-tools.enable = true;
  dotfiles.virtualization.enable = true;
  dotfiles.development-tools.neovim.language-servers.enable = true;
  dotfiles.window-managers.sway.enable = true;

  programs.git.signing = {
    key = "2DEB54D1D4413780";
    signByDefault = true;

  };
}


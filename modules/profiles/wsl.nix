{ pkgs, ... }: {
  imports = [ ../programs ];
  home.packages = with pkgs; [ openssh bash ];
  home.file.".profile".text = ''
    . $HOME/.nix-profile/etc/profile.d/nix.sh
    ${pkgs.fish}/bin/fish
  '';
  dotfiles.shell.enable = true;
  dotfiles.development-tools.enable = true;
  dotfiles.development-tools.neovim.language-servers.enable = true;
  dotfiles.shell.gpg-agent.enable = true;
  dotfiles.shell.keybase.enable = true;
  #dotfiles.tex.enable = true;
}


{ pkgs, ... }:

let
  extensions = (with pkgs.vscode-extensions; [ bbenoist.Nix ])
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "remote-ssh";
        publisher = "ms-vscode-remote";
        version = "0.47.2";
        sha256 = "04niirbkrzsm4wk22pr5dcfymnhqq4vn25xwkf5xvbpw32v1bpp3";
      }
      {
        name = "remote-ssh-edit";
        publisher = "ms-vscode-remote";
        version = "0.47.2";
        sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
      }
      {
        name = "nix-env-selector";
        publisher = "arrterian";
        version = "0.1.1";
        sha256 = "0fbpldyk7p3apvndhjzil4442czdgk7jgl96nl5kkdmqk4x7basm";
      }
      {
        name = "rust";
        publisher = "rust-lang";
        version = "0.7.0";
        sha256 = "16n787agjjfa68r6xv0lyqvx25nfwqw7bqbxf8x8mbb61qhbkws0";
      }
    ];
  vscode-with-extensions =
    pkgs.vscode-with-extensions.override { vscodeExtensions = extensions; };
in {
  home.packages = with pkgs; [
    slack
    riot-desktop
    thunderbird
    #libreoffice
    spotify
    pavucontrol
    bemenu
    termite
    inconsolata
    zathura
    seafile-client
    mako
    skype
    feh
    vpnc
    openconnect
    obs-studio
    grim
    slurp
    xdg-user-dirs
    vscode-with-extensions
  ];
}

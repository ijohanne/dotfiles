{
  dotfiles.user-settings = {
    git = {
      commit-name = "Ian Johannesen";
      commit-email = "ij@opsplaza.com";
    };
    gpg = {
      git-key = "6BD2201A9B42D8A4A7B70371D144CA04735855AC";
      ssh-keys = [ "155285F1319ACA9CA9A9CA3E258C23D13AE38CF3" ];
      public-keys = [{
        key-file = ./gpg-key-2DEB54D1D4413780.asc;
        key-id = "2DEB54D1D4413780";
        owner-trust = "4E51818D29D2A91BEBE3A7D02DEB54D1D4413780:6:";
      }];
    };
  };
}

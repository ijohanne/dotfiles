{ pkgs, ... }:

{
    programs.git = {
    enable = true;
    userName = "Ian Johannesen";
    userEmail = "ij@opsplaza.com";
    lfs.enable = true;
    extraConfig = { pull = { ff = "only"; }; };
  };
}


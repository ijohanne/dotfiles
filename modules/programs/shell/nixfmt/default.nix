{ pkgs, ... }:

{
  home.packages = with pkgs; [ haskellPackages.nixfmt ];

}

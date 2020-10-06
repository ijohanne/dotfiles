{ pkgs, ... }:

{
  home.packages = with pkgs; [ ldns ];

}

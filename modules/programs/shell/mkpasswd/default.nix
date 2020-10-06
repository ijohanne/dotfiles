{ pkgs, ... }:

{
  home.packages = with pkgs; [ mkpasswd ];

}

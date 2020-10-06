{ pkgs, ... }:

{
  home.packages = with pkgs; [ tcpdump ];

}


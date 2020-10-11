{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.manpages ];
  nixpkgs.config.allowUnfree = true;
  documentation.dev.enable = true;
}


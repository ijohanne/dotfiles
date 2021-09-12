{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [ ripgrep vim nixpkgs-fmt htop fish git ethtool ppp tcpdump conntrack-tools lm_sensors ];
  nix.maxJobs = lib.mkDefault 64;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nixpkgs.config.allowUnfree = true;
}

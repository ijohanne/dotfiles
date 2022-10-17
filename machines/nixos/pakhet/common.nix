{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [ ripgrep vim nixpkgs-fmt htop fish git ];
  time.timeZone = "Europe/Madrid";
  services.xserver.enable = false;
  services.openssh.enable = true;
  nix = {
    settings = {
      max-jobs = lib.mkDefault 64;
      substituters = [ "https://ijohanne.cachix.org" ];
      trusted-public-keys = [ "ijohanne.cachix.org-1:oDy0m6h+CimPEcaUPaTZpEyVk6FVFpYPAXrrA9L5i9M=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 180d";
    };
  };
}

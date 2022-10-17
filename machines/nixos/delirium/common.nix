{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [ ripgrep vim nixpkgs-fmt htop fish git ethtool ];
  hardware.cpu.intel.updateMicrocode = true;
  nix.maxJobs = lib.mkDefault 64;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    binaryCaches = [ "https://ijohanne.cachix.org" ];
    binaryCachePublicKeys = [ "ijohanne.cachix.org-1:oDy0m6h+CimPEcaUPaTZpEyVk6FVFpYPAXrrA9L5i9M=" ];
    trustedUsers = [
      "builder"
    ];
  };
}

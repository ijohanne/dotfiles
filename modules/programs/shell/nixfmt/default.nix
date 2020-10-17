{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.nixfmt.enable) {
    home.packages = with pkgs; [ haskellPackages.nixfmt ];
    programs.fish.shellAliases = {
      nixfmt-recursive =
        "${pkgs.fd}/bin/fd '.nix$' -t f --exec ${pkgs.haskellPackages.nixfmt}/bin/nixfmt {}";
    };
  };

}


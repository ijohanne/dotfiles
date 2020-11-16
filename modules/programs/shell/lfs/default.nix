{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.lfs.enable) {
    home.packages = with pkgs; [ lfs ];
    programs.fish.functions = {
      df = {
        body = ''
          string match -eq 'zfs' (mount)
            and lfs -a
            or lfs
        '';
      };
    };
  };
}

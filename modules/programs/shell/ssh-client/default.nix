{ lib, config, ... }:
with lib;
let
  hosts = concatStringsSep "\n\n" (forEach config.dotfiles.user-settings.trustedSshHosts (elem: concatStringsSep "\n" ([
    "Host ${elem.hostname}"
  ]
  ++ (optionals elem.forwardAgent
    [
      "  ForwardAgent yes"
    ])
  ++ (optionals (elem.forwardGpgTo != null) [
    "  StreamLocalBindUnlink yes"
    "  RemoteForward ${elem.forwardGpgTo} /run/user/1000/gnupg/S.gpg-agent"
  ])
  )));
in
{
  config = mkIf (config.dotfiles.shell.ssh-client.enable) {
    home.file.".ssh/config".text = lib.mkBefore hosts;
    programs.ssh = {
      enable = true;
      compression = true;
    };
  };
}

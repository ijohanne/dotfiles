{ config, sources ? import ../../nixpkgs, pkgs ? import sources.nixpkgs { }, ... }:

{
  users.users.ij = {
    isNormalUser = true;
    name = "ij";
    group = "adm";
    extraGroups = [
      "wheel"
      "disk"
      "audio"
      "video"
      "networkmanager"
      "systemd-journal"
      "docker"
      "dialout"
    ];
    createHome = true;
    uid = 1000;
    home = "/home/ij";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGL566DZXxjOA78LSP1zNYw3mazmpN8iyqQ4YEbGUSub ij@unixpimps.net"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDTkAnVmodQcuGe5nhE+xIVTnC6Lm5cqHUMkPuqjdwM1F1Q0CFtqlqKVJsUFI3pyngttCNts3DTuA37Y2Ug/bFmnLNte6Zw7HbxteBBxrp30BBFHy0KrBfSRC4JsxUE55h3irKTTAUpZNcuQ03jpErXtbMnsKduYUp2stcDt6uac1WEoefGMnh+FsVA/D5ZFtPUh7aGHOXjk7irPNwlSNa7UV8Pth/YaMy87YTKV8eaWXl+ozLLivEqdG6GlZIR74vNBQrEdkYCk9zNXH4kAxDH3Sm+mewmCiw6B/0GAQTdqBM73wi8TsG/6VuCnaWXGNyEjMfxD1Dm3xSc8h7Y87tKqkSinZZCQ9Ds2BVFv7MlVULQccSwJxN9kaPW4uq7sh5HTFsQhFE21jvYrxqxPdu//enJSCJ6SvGu6NmF63mBav4UbGllEVzwuT25kukgRVRlPrpGlrRCphA2wF9EnmwZzLAlwZwaccqCT1mE9Hu/laudb3csNC3zm122NI+VVYM= builder@ij-home"
    ];
  };

  users.defaultUserShell = pkgs.fish;
  users.mutableUsers = true;

  nix.trustedUsers = [ "ij" ];

  programs.fish.enable = true;
  programs.zsh.enable = true;
}

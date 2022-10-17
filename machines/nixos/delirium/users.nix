{ config, pkgs, lib, ... }:

{
  users.groups.srv = { };
  users.users.root.initialHashedPassword = "";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKeFunHfY3vS2izkp7fMHk2bXuaalNijYcctAF2NGc1T"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKiCGBgFgwbHB+2m++ViEnhoFjww2Twvx8gXWcMvHvz3 martin@martin8412.dk"
  ];
  users.users = {
    mj = {
      createHome = true;
      description = "Martin Karlsen Jensen";
      extraGroups = [
        "wheel"
      ];
      group = "adm";
      isNormalUser = true;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKiCGBgFgwbHB+2m++ViEnhoFjww2Twvx8gXWcMvHvz3 martin@martin8412.dk"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM+tKVOWTewbDOH2uMERekNUQ3DzKWVaqiTrPVZRGIrX mj@fatty"
      ];
    };
    ij = {
      createHome = true;
      description = "Ian Johannesen";
      extraGroups = [
        "wheel"
      ];
      group = "adm";
      isNormalUser = true;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKeFunHfY3vS2izkp7fMHk2bXuaalNijYcctAF2NGc1T"
      ];
    };
    builder = {
      description = "Remote builder";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKDNZPFUz5mtknErONI39/wKeepvZiGZHYJkq6LCth1f root@sobek"
      ];
    };
  };
}

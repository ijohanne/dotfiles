{
  imports =
    [ ../../../modules/profiles/desktop.nix ../../../modules/packages.nix ];

  home.sessionVariables = { DRI_PRIME = "1"; };
}

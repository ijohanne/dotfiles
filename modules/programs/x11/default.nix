{
  imports = [ ./communications ./media ./terminals ./office ];

  home.sessionVariables = {
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
    DRI_PRIME = "1";
  };

}


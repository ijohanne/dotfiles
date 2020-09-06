let sources = import ../nix;
in {
  programs.firefox = {
    enable = true;
    extensions = with sources.nur.repos.rycee.firefox-addons; [
      ublock-origin
      lastpass-password-manager
      reddit-enhancement-suite
    ];
  };

}

let
  sources = import ../nix;
  pkgs = import sources.nixpkgs { overlays = [ sources.mozilla-overlay ]; };
  nur = import sources.nur { inherit pkgs; };
in {
  programs.firefox = {
    enable = true;
    extensions = with nur.repos.rycee.firefox-addons; [
      ublock-origin
      lastpass-password-manager
      reddit-enhancement-suite
    ];
  };

}

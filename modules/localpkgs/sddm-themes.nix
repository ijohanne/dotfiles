{ pkgs, mkDerivation, qtbase, qtquickcontrols, qtgraphicaleffects }:
let sources = import ../../nix/sources.nix;
in {
  sddm-sugar-dark = mkDerivation rec {
    pname = "sddm-sugar-dark-theme";
    version = "1.2";
    dontBuild = true;
    buildInputs = [ qtbase qtquickcontrols qtgraphicaleffects ];
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/sugar-dark
    '';
    src = pkgs.fetchFromGitHub {
      inherit (sources.sddm-sugar-dark) owner repo rev sha256;
    };
  };
  sddm-chili = mkDerivation rec {
    pname = "sddm-sugar-chili-theme";
    version = "1.2";
    dontBuild = true;
    buildInputs = [ qtbase qtquickcontrols qtgraphicaleffects ];
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/chili
    '';
    src = pkgs.fetchFromGitHub {
      inherit (sources.sddm-chili) owner repo rev sha256;
    };
  };

}

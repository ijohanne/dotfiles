{ buildFirefoxXpiAddon, fetchurl, stdenv }: {
  "darkreader" = buildFirefoxXpiAddon {
    pname = "darkreader";
    version = "4.9.23";
    addonId = "addon@darkreader.org";
    url =
      "https://addons.mozilla.org/firefox/downloads/file/3667405/dark_reader-4.9.23-an+fx.xpi";
    sha256 = "bb063bbc1c098a1629711bf1d4c7cd96851c7fce14c327dcef296807f25f2c32";
    meta = with stdenv.lib; {
      homepage = "https://darkreader.org/";
      description =
        "Dark mode for every website. Take care of your eyes, use dark theme for night and daily browsing.";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };
}

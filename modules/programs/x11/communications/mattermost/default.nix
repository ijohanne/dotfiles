{ pkgs, lib, config, ... }:
let
  rpath = with pkgs; lib.makeLibraryPath [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gnome2.GConf
    gtk3
    pango
    libappindicator-gtk3
    libuuid
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    nspr
    nss
    stdenv.cc.cc
    udev
    xorg.libxcb
    xorg.libxshmfence
    libdrm
    libxkbcommon
    mesa
  ];
in
with lib; {
  config = mkIf (config.dotfiles.x11.communications.mattermost.enable) {
    home.packages = with pkgs; [
      (mattermost-desktop.overrideAttrs (_: {
        version = "5.0.0";
        src = pkgs.fetchurl {
          url = "https://releases.mattermost.com/desktop/5.0.0/mattermost-desktop-5.0.0-linux-x64.tar.gz";
          sha256 = "1rc2a1p0w47dp9bmvclmf5ljwkwxpf820khd82h3wsqqzgxn2q0r";
        };
        installPhase = ''
          runHook preInstall
          mkdir -p $out/share/mattermost-desktop
          cp -R . $out/share/mattermost-desktop
          mkdir -p "$out/bin"
          ln -s $out/share/mattermost-desktop/mattermost-desktop \
            $out/bin/mattermost-desktop
          patchShebangs $out/share/mattermost-desktop/create_desktop_file.sh
          $out/share/mattermost-desktop/create_desktop_file.sh
          rm $out/share/mattermost-desktop/create_desktop_file.sh
          mkdir -p $out/share/applications
          mv Mattermost.desktop $out/share/applications/Mattermost.desktop
          substituteInPlace \
            $out/share/applications/Mattermost.desktop \
            --replace /share/mattermost-desktop/mattermost-desktop /bin/mattermost-desktop
          patchelf \
            --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            --set-rpath "${rpath}:$out/share/mattermost-desktop" \
            $out/share/mattermost-desktop/mattermost-desktop
          runHook postInstall
        '';
      }))
    ];
  };
}

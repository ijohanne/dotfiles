{ pkgs, lib, config, ... }:
with pkgs;
with lib; {
  config = mkIf
    (config.dotfiles.x11.security.ledger-live-desktop.enable)
    {
      home.packages =
        let
          pname = "ledger-live-desktop";
          version = "2.29.0";
          name = "${pname}-${version}";

          src = fetchurl {
            url = "https://github.com/LedgerHQ/${pname}/releases/download/v${version}/${pname}-${version}-linux-x86_64.AppImage";
            sha256 = "1y4xvnwh2mqbc39pmnpgjg8mlx208s2pipm7dazq4bgmay7k9zh0";
          };

          appimageContents = appimageTools.extractType2 {
            inherit name src;
          };
          ledger-live-desktop = appimageTools.wrapType2 {
            inherit name src;

            extraInstallCommands = ''
              mv $out/bin/${name} $out/bin/${pname}
              install -m 444 -D ${appimageContents}/ledger-live-desktop.desktop $out/share/applications/ledger-live-desktop.desktop
              install -m 444 -D ${appimageContents}/ledger-live-desktop.png $out/share/icons/hicolor/1024x1024/apps/ledger-live-desktop.png
              ${imagemagick}/bin/convert ${appimageContents}/ledger-live-desktop.png -resize 512x512 ledger-live-desktop_512.png
              install -m 444 -D ledger-live-desktop_512.png $out/share/icons/hicolor/512x512/apps/ledger-live-desktop.png
              substituteInPlace $out/share/applications/ledger-live-desktop.desktop \
                --replace 'Exec=AppRun' 'Exec=${pname}'
            '';
          };
        in
        [
          ledger-live-desktop
        ];
    };

}

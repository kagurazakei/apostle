{
  lib,
  stdenvNoCC,
  symlinkJoin,
  makeWrapper,
  quickshell,
  kdePackages,
  material-symbols,
  makeFontsConf,
  nerd-fonts,
  qt6,
  libsForQt5,
  configPath ? ../dots/quickshell/rumda,
}:

let
  qmlPath = lib.makeSearchPath "lib/qt-6/qml" [
    qt6.qtdeclarative
    qt6.qtbase
    kdePackages.kirigami
    kdePackages.kirigami-addons
    kdePackages.qqc2-desktop-style
    kdePackages.qt5compat
    libsForQt5.qtgraphicaleffects
  ];

  fontconfig = makeFontsConf {
    fontDirectories = [
      material-symbols
      nerd-fonts.caskaydia-mono
    ];
  };

  # Simple config copy
  qsConfig = stdenvNoCC.mkDerivation {
    name = "rumdaconf";
    src = configPath;
    installPhase = ''
      mkdir -p $out
      cp -r $src/* $out/
    '';
  };

in
symlinkJoin {
  pname = "rumda";
  version = quickshell.version;
  paths = [ quickshell ];
  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    makeWrapper ${quickshell}/bin/quickshell $out/bin/rumda \
      --set FONTCONFIG_FILE "${fontconfig}" \
      --set QML2_IMPORT_PATH "${qmlPath}" \
      --set QT_QUICK_CONTROLS_STYLE "org.kde.desktop" \
      --add-flags '-p ${qsConfig}'
  '';

  meta.mainProgram = "rumda";
}

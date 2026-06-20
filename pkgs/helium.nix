{
  pkgs,
  sources,
  ...
}:

let
  heliumSrc = sources.helium;
  version = "nightly";
in
pkgs.stdenv.mkDerivation {
  pname = "helium";
  inherit version;

  src = heliumSrc;

  nativeBuildInputs =
    with pkgs;
    [
      makeWrapper
      autoPatchelfHook
      qt6.wrapQtAppsHook
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
      makeBinaryWrapper
    ];

  buildInputs =
    with pkgs;
    [
      glib
      gdk-pixbuf
      gtk3
      nspr
      nss
      dbus
      atk
      at-spi2-atk
      cups
      expat
      libxcb
      libxkbcommon
      at-spi2-core
      libx11
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
      mesa
      cairo
      pango
      systemd
      alsa-lib
      libdrm
      qt6.qtbase
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      libGL
      libva
      pipewire
      libpulseaudio
    ];

  # Ignore Qt5 shim, qt5webengine is unmaintained & we're using Qt6
  autoPatchelfIgnoreMissingDeps = pkgs.lib.optionals pkgs.stdenv.isLinux [
    "libQt5Core.so.5"
    "libQt5Gui.so.5"
    "libQt5Widgets.so.5"
  ];

  unpackCmd = pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
    mnt=$(TMPDIR=/tmp mktemp -d -t nix-XXXXXXXXXX)
    trap "/usr/bin/hdiutil detach $mnt -force; rm -rf $mnt" EXIT
    /usr/bin/hdiutil attach -nobrowse -readonly -mountpoint $mnt $curSrc
    cp --archive $mnt/Helium.app $PWD/
  '';

  sourceRoot = pkgs.lib.optionalString pkgs.stdenv.isDarwin ".";

  installPhase = ''
    runHook preInstall

    ${pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
      mkdir --parents $out/Applications
      cp --archive Helium.app $out/Applications/Helium.app

      mkdir --parents $out/bin
      makeBinaryWrapper $out/Applications/Helium.app/Contents/MacOS/Helium $out/bin/helium
    ''}

    ${pkgs.lib.optionalString pkgs.stdenv.isLinux ''
      mkdir --parents $out/opt/helium
      cp --recursive ./* $out/opt/helium/

      mkdir --parents $out/bin
      makeWrapper $out/opt/helium/helium-wrapper $out/bin/helium \
        --prefix LD_LIBRARY_PATH : "${
          pkgs.lib.makeLibraryPath [
            pkgs.libGL
            pkgs.libva
            pkgs.pipewire
            pkgs.libpulseaudio
          ]
        }"

      mkdir --parents $out/share/applications
      cp $out/opt/helium/helium.desktop $out/share/applications/

      mkdir --parents $out/share/pixmaps
      cp $out/opt/helium/product_logo_256.png $out/share/pixmaps/helium.png
    ''}

    runHook postInstall
  '';

  meta = {
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    description = "A private, fast, and honest web browser";
    homepage = "https://github.com/imputnet/helium";
    license = pkgs.lib.licenses.gpl3Only;
    mainProgram = "helium";
  };
}

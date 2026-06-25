{
  stdenv,
  makeWrapper,
  python3,
  wrapGAppsNoGuiHook,
  gobject-introspection,
}:
let
  pythonEnv = python3.withPackages (p: [
    p.dbus-python
    p.pygobject3
  ]);
in
stdenv.mkDerivation {
  name = "wifid";

  src = ./.;

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsNoGuiHook
    gobject-introspection
  ];

  installPhase = ''
    mkdir -p $out/bin

    cp $src/main.py $out/bin/wifid
    chmod +x $out/bin/wifid

    wrapProgram $out/bin/wifid --prefix PATH : ${pythonEnv}/bin
  '';

  meta.mainProgram = "wifid";
}

{
  lib,
  stdenv,
  sources ? import ../.tack,
  pkg-config,
  cmake,
  ninja,
  spirv-tools,
  vulkan-headers,
  qt6,
  kdePackages,
  cpptrace,
  jemalloc,
  cli11,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxcb,
  libdrm,
  libgbm,
  pipewire,
  pam,
  glib,
  polkit,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "quickshell";
  version = "0.3.0";

  # github mirror: https://github.com/quickshell-mirror/quickshell
  src = sources.quickshell;

  nativeBuildInputs = [
    cmake
    ninja
    qt6.qtshadertools
    spirv-tools
    vulkan-headers
    wayland-scanner
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwayland
    qt6.qtsvg
    kdePackages.kirigami
    kdePackages.kirigami-addons
    kdePackages.qqc2-desktop-style
    kdePackages.syntax-highlighting
    cli11
    wayland
    wayland-protocols
    libdrm
    libgbm
    cpptrace
    jemalloc
    libxcb
    pam
    pipewire
    glib
    polkit
  ];

  cmakeFlags = [
    (lib.cmakeFeature "DISTRIBUTOR" "Nixpkgs")
    (lib.cmakeFeature "INSTALL_QML_PREFIX" qt6.qtbase.qtQmlPrefix)
    (lib.cmakeFeature "GIT_REVISION" "tag-v${finalAttrs.version}")
  ];

  cmakeBuildType = "RelWithDebInfo";
  separateDebugInfo = true;
  dontStrip = false;

  meta = {
    homepage = "https://quickshell.org";
    description = "Flexbile QtQuick based desktop shell toolkit";
    license = lib.licenses.lgpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "quickshell";
    maintainers = with lib.maintainers; [ outfoxxed ];
  };
})

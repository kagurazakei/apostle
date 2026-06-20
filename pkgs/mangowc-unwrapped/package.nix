{
  lib,
  libX11,
  libinput,
  libxcb,
  libdrm,
  libxkbcommon,
  pcre2,
  pango,
  cjson,
  pixman,
  pkg-config,
  stdenv,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxcb-wm,
  xwayland,
  meson,
  ninja,
  scenefx,
  wlroots_0_19,
  libGL,
  enableXWayland ? true,
  debug ? false,
  sources,
}:
stdenv.mkDerivation {
  pname = "mango-unwrapped";
  version = if (sources.mango ? version) then sources.mango.version else "nightly";

  src = sources.mango;

  mesonFlags = [
    (lib.mesonEnable "xwayland" enableXWayland)
    (lib.mesonBool "asan" debug)
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libinput
    libxcb
    libxkbcommon
    pcre2
    pango
    cjson
    pixman
    wayland
    wayland-protocols
    wlroots_0_19
    scenefx
    libGL
    libdrm
  ]
  ++ lib.optionals enableXWayland [
    libX11
    libxcb-wm
    xwayland
  ];

  passthru = {
    providedSessions = [ "mango" ];
    uwsm-plugin = ./mango-plugin.sh;
  };

  meta = {
    mainProgram = "mango";
    description = "Practical and Powerful wayland compositor (dwm but wayland)";
    homepage = "https://github.com/mangowm/mango";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}

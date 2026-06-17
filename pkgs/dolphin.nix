{
  pkgs,
  symlinkJoin,
  makeWrapper,
  ...
}:
let
  k = pkgs.kdePackages;
  dolphinPluginsFixed = k.dolphin-plugins.overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [
      k.dolphin
    ];
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
      k.extra-cmake-modules
    ];

    cmakeFlags = (old.cmakeFlags or [ ]) ++ [
      "-DDolphinVcs_DIR=${k.dolphin}/lib/cmake/DolphinVcs"
    ];
  });
  baseDolphin = k.dolphin;
  dolphin = symlinkJoin {
    name = "dolphin";
    pname = "dolphin";
    version = baseDolphin.version or "unknown";

    paths = [
      baseDolphin
      dolphinPluginsFixed
    ];
    nativeBuildInputs = [ makeWrapper ];
    postBuild = ''
      rm $out/bin/dolphin
      makeWrapper ${k.dolphin}/bin/dolphin $out/bin/dolphin \
        --prefix PATH : "${pkgs.lib.makeBinPath [ k.kservice ]}" \
        --suffix XDG_CONFIG_DIRS : "${k.plasma-workspace}/etc/xdg" \
        --set XDG_MENU_PREFIX "plasma-" \
        --run "${k.kservice}/bin/kbuildsycoca6 --noincremental ${k.plasma-workspace}/etc/xdg/menus/plasma-applications.menu"
    '';
    meta = baseDolphin.meta // {
      description = "Dolphin with plugins + fixed menu + wrapper";
    };
  };
in
dolphin

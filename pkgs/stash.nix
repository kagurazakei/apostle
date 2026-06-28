{
  pkgs,
  symlinkJoin,
  sources ? import ../.tack,
}:
let
  stp = sources.stash.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
symlinkJoin {
  inherit (stp) meta version pname;
  paths = [ stp ];
  postBuild = ''
    rm $out/bin/wl-copy
    rm $out/bin/wl-paste
  '';
}

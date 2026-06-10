{
  pkgs,
  symlinkJoin,
  inputs ? import ../.tack,
}:
let
  stp = inputs.stash.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
symlinkJoin {
  inherit (stp) meta version pname;
  paths = [ stp ];
  postBuild = ''
    rm $out/bin/wl-copy
    rm $out/bin/wl-paste
  '';
}

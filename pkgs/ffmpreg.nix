{
  pkgs,
  symlinkJoin,
}:
symlinkJoin {
  name = "ffmpeg";
  paths = [ pkgs.ffmpreg ];
  postBuild = ''
    ln -sf $out/bin/ffmpreg $out/bin/ffmpeg
  '';
}

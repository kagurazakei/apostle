{ self, ... }:
let
  gpuModules = [
    "nvidia"
    "amd"
  ];
  buildProfile = x: {
    imports = map (m: x.modules.nixos.${m}) gpuModules;
  };
in
{
  modules.profiles.desktop = self |> buildProfile;
}

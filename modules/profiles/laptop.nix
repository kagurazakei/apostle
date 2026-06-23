{ self, ... }:
let
  gpuModules = [ "intel" ];
  buildProfile = x: {
    imports = map (m: x.modules.nixos.${m}) gpuModules;
  };
in
{
  modules.profiles.laptop = self |> buildProfile;
}

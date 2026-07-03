{ self, ... }:
let
  gpuModules = [ "intel" ];
  mpvModules = [ "mpv" ];

  getModules = category: names: map (name: category.${name}) names;
  buildProfile = x: {
    imports = getModules x.modules.nixos gpuModules ++ getModules x.modules.programs mpvModules;
  };
in
{
  modules.profiles.laptop = self |> buildProfile;
}

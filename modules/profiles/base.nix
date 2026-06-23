{ self, ... }:
let
  nixos = [
    "trash"
    "audio"
    "bluetooth"
    "bootloader"
    "env"
    "fonts"
    "locale"
    "networking"
    "nix"
    "nix-index-database"
    "misc"
    "packages"
    "kernel"
    "security"
    "inputs"
  ];

  services = [
    "scheduler"
    "openssh"
    "flatpak"
  ];

  hjem = [
    "_"
    "antonio"
    "hjem-impure"
  ];

  getModules = category: names: map (name: category.${name}) names;
  buildBaseProfile = x: {
    imports =
      getModules x.modules.nixos nixos
      ++ getModules x.modules.services services
      ++ getModules x.modules.hjem hjem;
  };
in
{
  modules.profiles.base = self |> buildBaseProfile;
}

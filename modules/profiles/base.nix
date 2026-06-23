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

  buildBaseProfile = x: {
    imports =
      (map (m: x.modules.nixos.${m}) nixos)
      ++ (map (s: x.modules.services.${s}) services)
      ++ (map (h: x.modules.hjem.${h}) hjem);
  };
in
{
  modules.profiles.base = self |> buildBaseProfile;
}

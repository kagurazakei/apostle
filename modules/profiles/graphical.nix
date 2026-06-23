{ self, ... }:
let
  nixos = [ "misc_steam" ];
  programs = [
    "dots_fish"
    "dots_hyprland"
    "dots_niri"
    "dots_mango"
    "dots_impure"
    "dots_yazi"
    "spicetify"
    "git"
    "dolphin"
    "fish"
    "impermanence"
    "librewolf"
    "nixcord"
    "agenix"
    "yazi"
    "zellij"
    "mpv"
    "noctalia"
  ];
  services = [
    "_sysc-greet"
    "_greetd"
    "noctalia-greeter"
  ];
  wm = [
    "_"
    "hyprland"
    "niri"
    "mango"
  ];
  getModules = category: names: map (name: category.${name}) names;
  buildProfile = x: {
    imports =
      getModules x.modules.nixos nixos
      ++ getModules x.modules.programs programs
      ++ getModules x.modules.services services
      ++ getModules x.modules.wm wm;
  };
in
{
  modules.profiles.graphical = self |> buildProfile;
}

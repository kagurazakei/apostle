{ self, ... }:
let
  modules = {
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
  };

  buildProfile = x: {
    imports =
      map (m: x.modules.nixos.${m}) modules.nixos
      ++ map (p: x.modules.programs.${p}) modules.programs
      ++ map (s: x.modules.services.${s}) modules.services
      ++ map (w: x.modules.wm.${w}) modules.wm;
  };
in
{
  modules.profiles.graphical = self |> buildProfile;
}

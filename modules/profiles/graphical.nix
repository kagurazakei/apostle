{ self, ... }:
{
  modules.profiles.graphical = {
    imports = [
      self.modules.nixos.misc_steam
      self.modules.programs.dots_fish
      self.modules.programs.dots_hyprland
      self.modules.programs.dots_niri
      self.modules.programs.dots_mango
      self.modules.programs.dots_impure
      self.modules.programs.dots_yazi
      self.modules.programs.spicetify
      self.modules.programs.git
      self.modules.programs.dolphin
      self.modules.programs.equibop
      self.modules.programs.fish
      self.modules.programs.impermanence
      self.modules.programs.librewolf
      self.modules.programs.helium-browser
      self.modules.programs.agenix
      self.modules.programs.yazi
      self.modules.programs.mpv
      self.modules.programs.noctalia
      self.modules.services._sysc-greet
      self.modules.services._greetd
      self.modules.services.noctalia-greeter
      self.modules.wm._
      self.modules.wm.hyprland
      self.modules.wm.niri
      self.modules.wm.mango
    ];
  };
}

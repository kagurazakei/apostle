{ self, ... }:
{
  modules.profiles.graphical = {
    imports = [
      self.modules.programs.dots_fish
      self.modules.programs.dots_hyprland
      self.modules.programs.dots_niri
      self.modules.programs.dots_mango
      self.modules.programs.dots_impure
      self.modules.programs.dots_yazi
      self.modules.wm._
      self.modules.wm.hyprland
      self.modules.wm.niri
      self.modules.wm.mango
    ];
  };
}

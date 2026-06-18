{ self, ... }:
{
  modules.profiles.desktop = {
    imports = [
      self.modules.nixos.nvidia
      self.modules.nixos.amd
    ];
  };
}

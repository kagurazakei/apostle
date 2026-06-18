{ self, ... }:
{
  modules.profiles.laptop = {
    imports = [
      self.modules.nixos.intel
    ];
  };
}

{ self, ... }:
{
  modules.profiles.base = {
    imports = [
      self.modules.nixos.trash
      self.modules.nixos.audio
      self.modules.nixos.bluetooth
      self.modules.nixos.bootloader
      self.modules.nixos.env
      self.modules.nixos.fonts
      self.modules.nixos.locale
      self.modules.nixos.networking
      self.modules.nixos.nix
      self.modules.nixos.nix-index-database
      self.modules.nixos.misc
      self.modules.nixos.packages
      self.modules.nixos.kernel
      self.modules.nixos.security
      self.modules.nixos.inputs
      self.modules.services.scheduler
      self.modules.services.openssh
      self.modules.services.flatpak
      self.modules.hjem._
      self.modules.hjem.antonio
      self.modules.hjem.hjem-impure
    ];
  };
}

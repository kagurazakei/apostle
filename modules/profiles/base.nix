{ self, ... }:
{
  modules.profiles.base = {
    imports = [
      self.modules.nixos.misc_steam
      self.modules.programs.spicetify
      self.modules.programs.git
      self.modules.programs.dolphin
      self.modules.programs.fish
      self.modules.programs.impermanence
      self.modules.programs.agenix
      self.modules.programs.yazi
      self.modules.programs.mpv
      self.modules.programs.noctalia
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
      self.modules.services._sysc-greet
      self.modules.services._greetd
      self.modules.services.noctalia-greeter
      self.modules.hjem._
      self.modules.hjem.antonio

    ];
  };
}

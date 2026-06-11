{
  self,
  ...
}:
let
  hostname = "hana";
in
{
  modules.hosts.${hostname} = {
    imports = [
      self.modules.nixos.misc_steam
      self.modules.programs.dots_fish
      self.modules.programs.dots_hyprland
      self.modules.programs.dots_niri
      self.modules.programs.dots_mango
      self.modules.programs.dots_impure
      self.modules.programs.dots_yazi
      self.modules.programs.spicetify
      self.modules.programs.ambxst
      self.modules.programs.git
      self.modules.programs.dolphin
      self.modules.programs.fish
      self.modules.programs.impermanence
      self.modules.programs.agenix
      self.modules.programs.yazi
      self.modules.programs.mpv
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
      self.modules.nixos.nvidia
      self.modules.nixos.amd
      self.modules.nixos.kernel
      self.modules.nixos.security
      self.modules.services.scheduler
      self.modules.services.openssh
      self.modules.services.flatpak
      self.modules.services._sysc-greet
      self.modules.services._greetd
      self.modules.services.noctalia-greeter
      self.modules.wm._
      self.modules.wm.hyprland
      self.modules.wm.niri
      self.modules.wm.mango

      self.modules.hjem._
      self.modules.hjem.antonio

      ./+hardware.nix
    ];
    greeny = {
      secrets = {
        antonioPass = {
          file = self.paths.secrets + /hana-user.age;
          owner = "antonio";
        };
        tailAuth = {
          file = self.paths.secrets + /tailscale.age;
          owner = "antonio";
        };
        secret2 = {
          file = self.paths.secrets + /hana-access-token.age;
          owner = "antonio";
          mode = "0500";
          path = "/etc/nix/nix-access-token.conf";
        };
        recovery = {
          file = self.paths.secrets + /recovery.age;
          owner = "antonio";
          mode = "0500";
          path = "/etc/keys/recovery.txt";
        };
        anilist = {
          file = self.paths.secrets + /anilist.age;
          owner = "antonio";
          mode = "0500";
          path = "/etc/keys/anilist.txt";
        };
        ssh-kagura = {
          file = self.paths.secrets + /ssh-hana.age;
          owner = "antonio";
          mode = "0500";
          path = "/etc/keys/ssh-hana";
        };
      };
    };
    networking.hostName = hostname;
    system.stateVersion = "26.11";
  };
}

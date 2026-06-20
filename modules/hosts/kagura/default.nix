{
  self,
  username,
  ...
}:
let
  hostname = "kagura";
  dots = "${self.paths.dots}";
  iconSource = dots + "/images/profile.png"; # Define once
in
{
  modules.hosts.${hostname} = {
    imports = [
      self.modules.profiles.base
      self.modules.profiles.graphical
      self.modules.profiles.laptop
      ./+hardware.nix
    ];
    greeny = {
      secrets = {
        antonioPass = {
          file = self.paths.secrets + /kagura-user.age;
          owner = "antonio";
        };
        tailAuth = {
          file = self.paths.secrets + /tailscale.age;
          owner = "antonio";
          path = "/etc/keys/tailAuth.txt";
        };
        secret2 = {
          file = self.paths.secrets + /kagura-access-token.age;
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
          file = self.paths.secrets + /kagura-ssh.age;
          owner = "antonio";
          mode = "0500";
          path = "/etc/keys/ssh-kagura";
        };
        cachix = {
          file = self.paths.secrets + /cachix-token.age;
          owner = "antonio";
          mode = "0500";
          path = "/etc/keys/cachix.dhall";
        };
      };
    };
    nixos = {
      graphics.intel.hwAccelDriver = "media-driver";
    };
    networking.hostName = hostname;
    system.stateVersion = "26.05";
    systemd.tmpfiles.rules = [
      # AccountsService user file
      "f+ /var/lib/AccountsService/users/${username} 0600 root root - \
[User]\nIcon=/var/lib/AccountsService/icons/${username}\n"
      "L+ /var/lib/AccountsService/icons/${username} - - - - ${iconSource}"
    ];

  };
}

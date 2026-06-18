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
      self.modules.profiles.base
      self.modules.profiles.graphical
      self.modules.profiles.desktop
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
        ssh-hana = {
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

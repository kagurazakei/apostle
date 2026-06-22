{
  self,
  username,
  lib,
  ...
}:
let
  hostname = "hana";
  dots = "${self.paths.dots}";
  iconSource = dots + "/images/profile.png";
  hostModule = lib.pipe self [
    (x: {
      modules.hosts.${hostname} = {
        imports = [
          x.modules.profiles.base
          x.modules.profiles.graphical
          x.modules.profiles.desktop
          ./+hardware.nix
        ];
        greeny.secrets = {
          antonioPass = {
            file = x.paths.secrets + /hana-user.age;
            owner = "antonio";
          };
          tailAuth = {
            file = x.paths.secrets + /tailscale.age;
            owner = "antonio";
          };
          secret2 = {
            file = x.paths.secrets + /kagura-access-token.age;
            owner = "antonio";
            mode = "0500";
            path = "/etc/nix/nix-access-token.conf";
          };
          recovery = {
            file = x.paths.secrets + /recovery.age;
            owner = "antonio";
            mode = "0500";
            path = "/etc/keys/recovery.txt";
          };
          anilist = {
            file = x.paths.secrets + /anilist.age;
            owner = "antonio";
            mode = "0500";
            path = "/etc/keys/anilist.txt";
          };
          ssh-hana = {
            file = x.paths.secrets + /ssh-hana.age;
            owner = "root";
            path = "/etc/keys/ssh-hana";
          };
          cachix = {
            file = x.paths.secrets + /cachix-token.age;
            owner = "antonio";
            mode = "0500";
            path = "/etc/keys/cachix.dhall";
          };
        };
        networking.hostName = hostname;
        system.stateVersion = "26.11";
        systemd.tmpfiles.rules = [
          "f+ /var/lib/AccountsService/users/${username} 0600 root root - [User]\nIcon=/var/lib/AccountsService/icons/${username}\n"
          "L+ /var/lib/AccountsService/icons/${username} - - - - ${iconSource}"
        ];
      };
    })
  ];
in
hostModule

{
  self,
  username,
  lib,
  ...
}:
let
  hostname = "kagura";
  dots = "${self.paths.dots}";
  iconSource = dots + "/images/profile.png";

  hostModule = lib.pipe self [
    (x: {
      modules.hosts.${hostname} = {
        imports = [
          x.modules.profiles.base
          x.modules.profiles.graphical
          x.modules.profiles.laptop
          ./+hardware.nix
        ];
        greeny.secrets = {
          antonioPass = {
            file = x.paths.secrets + /kagura-user.age;
            owner = "antonio";
          };
          tailAuth = {
            file = x.paths.secrets + /tailscale.age;
            owner = "antonio";
            path = "/etc/keys/tailAuth.txt";
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
          ssh-kagura = {
            file = x.paths.secrets + /kagura-ssh.age;
            path = "/etc/keys/ssh-kagura";
            owner = "root";
          };
          cachix = {
            file = x.paths.secrets + /cachix-token.age;
            owner = "antonio";
            mode = "0500";
            path = "/etc/keys/cachix.dhall";
          };
        };
        nixos.graphics.intel.hwAccelDriver = "media-driver";
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

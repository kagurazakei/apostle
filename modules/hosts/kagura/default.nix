{
  self,
  username,
  ...
}:
let
  hostname = "kagura";
  iconSource = "${self.paths.dots}/images/profile.png";

  hostModule =
    self
    |> (x: {
      modules.hosts.${hostname} = {
        imports = [
          x.modules.profiles.base
          x.modules.profiles.graphical
          x.modules.profiles.laptop
          ./+hardware.nix
        ];
        greeny.secrets = {
          antonioPass.file = x.paths.secrets + /kagura-user.age;
          antonioPass.owner = "antonio";
          tailAuth.file = x.paths.secrets + /tailscale.age;
          tailAuth.owner = "antonio";
          tailAuth.path = "/etc/keys/tailAuth.txt";
          secret2.file = x.paths.secrets + /kagura-access-token.age;
          secret2.owner = "antonio";
          secret2.mode = "0500";
          secret2.path = "/etc/nix/nix-access-token.conf";
          recovery.file = x.paths.secrets + /recovery.age;
          recovery.owner = "antonio";
          recovery.mode = "0500";
          recovery.path = "/etc/keys/recovery.txt";
          anilist.file = x.paths.secrets + /anilist.age;
          anilist.owner = "antonio";
          anilist.mode = "0500";
          anilist.path = "/etc/keys/anilist.txt";
          ssh-kagura.file = x.paths.secrets + /kagura-ssh.age;
          ssh-kagura.path = "/etc/keys/ssh-kagura";
          ssh-kagura.owner = "root";
          cachix.file = x.paths.secrets + /cachix-token.age;
          cachix.owner = "antonio";
          cachix.mode = "0500";
          cachix.path = "/etc/keys/cachix.dhall";
        };
        nixos.graphics.intel.hwAccelDriver = "media-driver";
        networking.hostName = hostname;
        system.stateVersion = "26.11";
        systemd.tmpfiles.rules = [
          "f+ /var/lib/AccountsService/users/${username} 0600 root root - [User]\nIcon=/var/lib/AccountsService/icons/${username}\n"
          "L+ /var/lib/AccountsService/icons/${username} - - - - ${iconSource}"
        ];
      };
    });
in
hostModule

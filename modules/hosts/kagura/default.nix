{
  self,
  username,
  ...
}:
{
  hostname = "kagura";
  iconSource = "${self.paths.dots}/images/profile.png";
}
|> (
  ctx:
  self
  |> (x: {
    modules.hosts.${ctx.hostname} = {
      imports = [
        x.modules.profiles.base
        x.modules.profiles.graphical
        x.modules.profiles.laptop
        ./+hardware.nix
      ];
      greeny.secrets =
        [
          {
            name = "antonioPass";
            file = "kagura-user.age";
          }
          {
            name = "tailAuth";
            file = "tailscale.age";
            path = "/home/${username}/.config/keys/tailAuth.txt";
          }
          {
            name = "secret2";
            file = "kagura-access-token.age";
            mode = "0500";
            path = "/etc/nix/nix-access-token.conf";
          }
          {
            name = "recovery";
            file = "recovery.age";
            mode = "0500";
            path = "/home/${username}/.config/keys/recovery.txt";
          }
          {
            name = "anilist";
            file = "anilist.age";
            mode = "0500";
            path = "/home/${username}/.config/keys/anilist.txt";
          }
          {
            name = "ssh-kagura";
            file = "kagura-ssh.age";
            owner = "root";
            path = "/home/${username}/.config/keys/ssh-kagura";
          }
          {
            name = "cachix";
            file = "cachix-token.age";
            mode = "0500";
            path = "/etc/keys/cachix.dhall";
          }
        ]
        |> (
          list:
          builtins.listToAttrs (
            map (s: {
              inherit (s) name;
              value = {
                file = x.paths.secrets + "/${s.file}";
                owner = s.owner or "antonio";
              }
              // (if s ? mode then { inherit (s) mode; } else { })
              // (if s ? path then { inherit (s) path; } else { });
            }) list
          )
        );

      nixos.graphics.intel.hwAccelDriver = "media-driver";
      networking.hostName = ctx.hostname;
      system.stateVersion = "26.11";

      systemd.tmpfiles.rules = [
        "f+ /var/lib/AccountsService/users/${username} 0600 root root - [User]\nIcon=/var/lib/AccountsService/icons/${username}\n"
        "L+ /var/lib/AccountsService/icons/${username} - - - - ${ctx.iconSource}"
        "Z /persistent/etc/sops-nix/kagura.txt 0640 root wheel -rw-r--"
        "d /persistent/etc/sops-nix 0750 root wheel -"
      ];
    };
  })
)

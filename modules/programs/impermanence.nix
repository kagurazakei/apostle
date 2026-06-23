{ inputs, username, ... }:
{
  modules.programs.impermanence = {
    imports = [
      (inputs.impermanence + "/nixos.nix")
    ];
    environment.persistence."/persistent" = {
      enable = true; # NB: Defaults to true, not needed
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
        "/etc/sops-nix"
      ];
      users.${username} = {
        directories = [
          {
            directory = ".ssh";
            mode = "0700";
          }
          {
            directory = ".config/keys";
            mode = "0700";
          }
          {
            directory = ".local/share/keyrings";
            mode = "0700";
          }
        ];
        files = [
          ".screenrc"
        ];
      };
    };
  };
}

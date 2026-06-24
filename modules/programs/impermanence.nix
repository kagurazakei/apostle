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
        {
          directory = "/etc/sops-nix";
          user = "root";
          group = "wheel";
          mode = "u=rwx,g=rx,o=";
        }
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
      };
    };
  };
}

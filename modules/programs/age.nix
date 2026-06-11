{ inputs, username, ... }:
{
  modules.programs.agenix =
    {
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        (inputs.agenix + "/modules/age.nix")
        (lib.mkAliasOptionModule [ "greeny" "secrets" ] [ "age" "secrets" ])
      ];
      environment.systemPackages = [
        (pkgs.callPackage "${inputs.agenix}/pkgs/agenix.nix" { })
      ];
      age.identityPaths = [
        "/persistent/etc/sops-nix/keys.txt"
        "/persistent/etc/sops-nix/id_ed25519"
      ]
      ++ builtins.map (username: "/home/${username}/.ssh/id_ed25519") [ username ];

    };
}

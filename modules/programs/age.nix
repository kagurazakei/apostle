{
  inputs,
  username,
  ...
}:
{
  modules.programs.agenix =
    {
      lib,
      pkgs,
      config,
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
        "/etc/sops-nix/${config.networking.hostName}.txt"
      ]
      ++ builtins.map (username: "/home/${username}/.ssh/id_ed25519") [ username ];

    };
}

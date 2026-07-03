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
        inputs.agenix.nixosModules.default
        (lib.mkAliasOptionModule [ "greeny" "secrets" ] [ "age" "secrets" ])
      ];
      environment.systemPackages = [
        inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      age.identityPaths = [
        "/etc/sops-nix/${config.networking.hostName}.txt"
      ]
      ++ builtins.map (username: "/home/${username}/.ssh/id_ed25519") [ username ];

    };
}

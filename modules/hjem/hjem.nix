{
  inputs,
  ...
}:
{
  modules.hjem._ =
    { pkgs, ... }:
    {
      imports = [ inputs.hjem.nixosModules.default ];

      hjem = {
        linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
        clobberByDefault = true;
        extraModules = [
          inputs.qtengine.hjemModules.default
          inputs.hjem-impure.hjemModules.default
          inputs.hjem-rum.hjemModules.default
        ];
      };
    };
}

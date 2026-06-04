{
  inputs,
  with-inputs,
  ...
}:
{
  modules.hjem._ =
    { pkgs, ... }:
    {
      imports = [ inputs.hjem.finixModules.default ];

      hjem = {
        linker = with-inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
        clobberByDefault = true;
        extraModules = [
          inputs.qtengine.hjemModules.default
          inputs.hjem-impure.hjemModules.default
          with-inputs.hjem-rum.hjemModules.default
        ];
      };
    };
}

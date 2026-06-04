{
  inputs,
  utils,
  with-inputs,
  ...
}:
let
in
{
  modules.hjem._ =
    { pkgs, ... }:
    let
      qtengineOut = utils._flakeToNix {
        src = inputs.qtengine;
        overrides = {
          nixpkgs = pkgs.path; # all qt apps need "follows"
        };
      };
    in
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

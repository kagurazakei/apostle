{
  inputs,
  ...
}:
{
  modules.programs.ambxst = {
    imports = [
      inputs.Ambxst.nixosModules.default
    ];
    programs.ambxst = {
      enable = true;
      fonts.enable = true;
    };
  };
}

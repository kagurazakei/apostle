{
  inputs,
  ...
}:
{
  modules.programs.ambxst = {
    imports = [
      inputs.ambxst.nixosModules.default
    ];
    programs.ambxst = {
      enable = true;
      fonts.enable = true;
    };
  };
}

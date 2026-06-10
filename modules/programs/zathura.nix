{
  modules.programs.zathura =
    {
      pkgs,
      config,
      ...
    }:
    {
      hj = {
        packages = with pkgs; [
          zathura
        ];
      };
    };
}

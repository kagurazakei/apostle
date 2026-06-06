{ inputs, ... }:
{
  modules.services.flatpak =
    { pkgs, ... }:
    {
      imports = [
        (inputs.nix-flatpak + "/modules/hjem.nix")
      ];
      services = {
        flatpak = {
          enable = true;
          packages = [
            "com.github.tchx84.Flatseal"
            "app.opencomic.OpenComic"
          ];
        };
      };
    };
}

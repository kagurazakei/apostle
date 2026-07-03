{ self, ... }:
{
  categories = [
    {
      target = "nixos";
      modules = [
        "trash"
        "audio"
        "bluetooth"
        "bootloader"
        "env"
        "fonts"
        "locale"
        "networking"
        "nix"
        "nix-index-database"
        "misc"
        "packages"
        "kernel"
        "security"
        "inputs"
      ];
    }
    {
      target = "services";
      modules = [
        "scheduler"
        "openssh"
        "flatpak"
      ];
    }
    {
      target = "hjem";
      modules = [
        "_"
        "antonio"
        "hjem-impure"
      ];
    }
  ];
}
|> (
  ctx:
  self
  |> (x: {
    modules.profiles.base = {
      imports =
        ctx.categories
        |> (map (c: map (name: x.modules.${c.target}.${name}) c.modules))
        |> builtins.concatLists;
    };
  })
)

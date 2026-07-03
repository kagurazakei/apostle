{ self, ... }:
{
  categories = [
    {
      target = "nixos";
      modules = [ "intel" ];
    }
    {
      target = "programs";
      modules = [ "mpv" ];
    }
  ];
}
|> (
  ctx:
  self
  |> (x: {
    modules.profiles.laptop = {
      imports =
        ctx.categories
        |> (map (c: map (name: x.modules.${c.target}.${name}) c.modules))
        |> builtins.concatLists;
    };
  })
)

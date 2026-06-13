{
  modules.nixos.env =
    { pkgs, ... }:
    {
      environment.variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        SUDO_EDITOR = "nvim";
        TACK_NIX_CONF_TOKEN = "1";
      };

      environment.etc = {
        "nixos/nixpkgs".source = builtins.storePath pkgs.path;
      };
    };
}

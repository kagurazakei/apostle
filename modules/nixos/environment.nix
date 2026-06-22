{
  modules.nixos.env =
    { pkgs, ... }:
    {
      security.pam.environment = {
        EDITOR.default = "nvim";
        VISUAL.default = "nvim";
        SUDO_EDITOR.default = "nvim";
        LIBVA_DRIVER_NAME.default = "iHD";
      };
      environment.etc.subuid.mode = "0444";
      environment.etc.subgid.mode = "0444";

      environment.etc.subuid.text = "antonio:100000:65536";
      environment.etc.subgid.text = "antonio:100000:65536";
      environment.etc = {
        "nixos/nixpkgs".source = builtins.storePath pkgs.path;
      };
    };
}

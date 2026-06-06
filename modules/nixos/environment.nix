{
  modules.nixos.env =
    { pkgs, ... }:
    {
      security.pam.environment = {
        EDITOR.default = "nvim";
        VISUAL.default = "nvim";
        SUDO_EDITOR.default = "nvim";
      };
      environment.etc = {
        "nixos/nixpkgs".source = builtins.storePath pkgs.path;
        # "/xdg/menus/applications.menu".text = builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu"; #dolphin fix
      };
    };
}

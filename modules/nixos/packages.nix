{ inputs, zpkgs, ... }:
{
  modules.nixos.packages =
    {
      pkgs,
      lib,
      config,
      system,
      ...
    }:
    let
      npins =
        if (config.nixos.packages.npins.buildFromSrc) then
          (pkgs.callPackage (inputs.npins + "/npins.nix") { })
        else
          pkgs.npins;
      cursors = inputs.waifu-cursors.packages.${system}.all;
    in
    {
      options = {
        nixos.packages.npins.buildFromSrc = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
      };
      config = {
        programs.direnv = {
          enable = true;
          loadInNixShell = true;
          nix-direnv.enable = true;
          enableFishIntegration = true;
        };

        environment.systemPackages = [
          npins
          cursors
        ]
        ++ builtins.attrValues {
          inherit (zpkgs)
            gtk-themes
            viu
            stash
            rumda
            ;
          inherit (zpkgs.scripts)
            npins-ui
            npins-show
            npins-helper
            nixy
            lutui
            touchpad-toggle
            ;
          inherit (pkgs.master)
            nh
            cachix
            equibop
            ;
          inherit (pkgs)
            zed-editor
            ffmpeg
            nix-init
            neovide
            git
            gh
            just
            gnupg
            lolcat
            yazi
            neovim
            wl-clipboard
            cliphist
            libnotify
            librewolf
            gtk-engine-murrine
            rose-pine-icon-theme
            rose-pine-gtk-theme
            vscodium
            ;
        };
      };
    };
}

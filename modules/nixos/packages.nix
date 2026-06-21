{
  inputs,
  ...
}:
{
  modules.nixos.packages =
    {
      pkgs,
      lib,
      config,
      system,
      tack,
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
      imports = [
        tack.nixosModules.default
      ];
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
        programs.tack = {
          enable = true;
          nixConfTokens = true;
        };
        environment.systemPackages = [
          npins
          cursors
        ]
        ++ builtins.attrValues {
          inherit (pkgs)
            ffmpeg
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
            gtk-engine-murrine
            vscodium
            noctalia-shell
            tmux
            tmuxp
            zathura
            ;
          inherit (pkgs.zathuraPkgs) zathura_pdf_mupdf;
        };
      };
    };
}

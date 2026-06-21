{
  inputs,
}:
[
  inputs.niri-nix.overlays.niri-nix
  inputs.nix-cachyos-kernel.overlays.pinned
  inputs.neovim-nightly.overlays.default
  inputs.helium-browser.overlays.default
  (_final: prev: {
    inherit (prev.stdenv.hostPlatform) system;
    master = import inputs.master {
      inherit (prev.stdenv.hostPlatform) system;
      config.allowUnfree = true;
      config.permittedInsecurePackages = [
        "librewolf-unwrapped-151.0.2-1"
        "librewolf-151.0.2-1"
      ];
    };
    stable = import inputs.nixos-stable {
      inherit (prev.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
  })
]

{
  inputs,
}:
[
  inputs.niri-nix.overlays.niri-nix
  inputs.nix-cachyos-kernel.overlays.pinned
  inputs.neovim-nightly.overlays.default
  (import inputs.dolphin-overlay)
  (_final: prev: {
    inherit (prev.stdenv.hostPlatform) system;
    master = import inputs.master {
      inherit (prev.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
    stable = import inputs.stable {
      inherit (prev.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
  })
]

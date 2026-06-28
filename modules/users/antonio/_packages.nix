{
  pkgs,
  inputs,
  zpkgs,
  self,
}:
let
  sixvim = inputs.mnw.lib.wrap { inherit pkgs inputs; } (self.paths.dots + /neovim);
in
builtins.attrValues {
  ### privacy tools
  inherit (pkgs)
    seahorse
    proton-vpn
    ripdrag
    ;
  ### image viewer and media related
  inherit (pkgs)
    awww
    mpvpaper
    yt-dlp
    qimgv
    inkscape
    fuzzel
    swappy
    viewnior
    imv
    ayugram-desktop
    mangayomi
    komikku
    ;
  ### editor
  inherit (pkgs)
    ollama
    neovide
    ;
  ### terminal emulators
  inherit (pkgs)
    ghostty
    kitty
    foot
    ;
  ### screenshot tools
  inherit (pkgs)
    gpu-screen-recorder-gtk
    wayfreeze
    hyprshot
    gpu-screen-recorder
    wf-recorder
    wl-screenrec
    grim
    slurp
    wl-clipboard
    imagemagick
    ;
  inherit (pkgs)
    git
    jq
    fd
    ripgrep
    ouch
    findutils
    brightnessctl
    duf
    lazygit
    trashy
    wtype
    socat
    resvg
    libnotify
    hyprsunset
    app2unit
    libsixel
    nwg-look
    gtkmm4
    networkmanagerapplet
    ;
  ### terminal fancy tools
  inherit (pkgs)
    btop
    bottom
    sysstat
    eza
    tree
    fastfetch
    microfetch
    bat
    zoxide
    fzf
    nitch
    htop
    ;
  inherit (pkgs.master)
    nh
    cachix
    ;

  inherit (zpkgs)
    gtk-themes
    viu
    stash
    quickshell
    helium
    ;

  inherit (zpkgs.scripts)
    nixy
    lutui
    touchpad-toggle
    ;

  inherit (pkgs.kdePackages)
    ark
    breeze
    qtsvg
    ;

}
++ [
  (pkgs.wrapOBS {
    plugins = [ pkgs.obs-studio-plugins.obs-pipewire-audio-capture ];
  })
  sixvim
]

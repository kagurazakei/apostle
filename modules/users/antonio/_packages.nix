{
  pkgs,
  inputs,
  zpkgs,
  self,
}:
let
  vixvim = inputs.mnw.lib.wrap { inherit pkgs inputs; } (self.paths.dots + /neovim);

in
builtins.attrValues {
  inherit (pkgs) awww;
  inherit (zpkgs)
    gtk-themes
    viu
    stash
    equibop
    quickshell
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
    ayugram-desktop
    neovide
    ;
  inherit (pkgs)
    inkscape
    fuzzel
    swappy
    viewnior
    git
    komikku
    nwg-look
    mangayomi
    ;
  inherit (pkgs)
    zed-editor
    zed-discord-presence
    nil
    nixd
    btop
    bottom
    sysstat
    eza
    tree
    fastfetch
    microfetch
    bat
    zoxide
    hyprshot
    ;
  inherit (pkgs)
    gpu-screen-recorder-gtk
    wf-recorder
    yt-dlp
    jq
    fd
    ripgrep
    fzf
    ouch
    kitty
    wl-clipboard
    cliphist
    mpvpaper
    findutils
    gtkmm4
    qimgv
    brightnessctl
    duf
    lazygit
    gpu-screen-recorder
    ;

  inherit (pkgs) trashy wl-screenrec;
  inherit (pkgs)

    wtype
    socat
    grim
    slurp
    imagemagick
    resvg
    ;
  inherit (pkgs)
    libnotify
    imv
    wayfreeze
    networkmanagerapplet
    ;
  inherit (pkgs)
    nitch
    htop
    ;
  inherit (pkgs)
    hyprsunset
    ripdrag
    seahorse
    app2unit
    ollama
    proton-vpn
    ;
  inherit (pkgs) foot libsixel;
  inherit (pkgs.kdePackages)
    ark
    breeze
    qtsvg
    ;
}
++ [
  (pkgs.mpv.override {
    scripts = [
      pkgs.mpvScripts.mpris
    ];
  })
  (pkgs.wrapOBS {
    plugins = [ pkgs.obs-studio-plugins.obs-pipewire-audio-capture ];
  })
  vixvim

]

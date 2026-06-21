{
  modules.nixos.security =
    { pkgs, ... }:
    {
      security = {
        pki.certificateFiles = [
          "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        ];
        sudo.enable = false;
        sudo-rs = {
          enable = true;
          wheelNeedsPassword = false;
          extraConfig = ''
            Defaults pwfeedback
            Defaults env_keep += "EDITOR PATH DISPLAY"
            Defaults passprompt = "[sudo 󱅞 ]: "
          '';
        };
      };
    };
}

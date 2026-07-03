{
  modules.hjem.antonio =
    let
      textEditors = [ "nvim.desktop" ];
      imageViewers = [ "viewnior.desktop" ];
      browsers = [ "firefox.desktop" ];
      pdfViewers = [ "org.pwmt.zathura.desktop" ];
      fileManagers = [ "org.kde.dolphin.desktop" ];
      mimeTypes = {
        # Text files
        "application/xml" = textEditors;
        "application/toml" = textEditors;
        "application/yml" = textEditors;
        "text/plain" = textEditors;
        "text/x-csrc" = textEditors;

        # Images
        "image/png" = imageViewers;
        "image/jpg" = imageViewers;
        "image/webp" = imageViewers;
        "image/svg+xml" = imageViewers;
        "image/jpeg" = imageViewers;

        # PDF
        "application/pdf" = pdfViewers;

        # Web
        "x-scheme-handler/http" = browsers;
        "x-scheme-handler/https" = browsers;
        "x-scheme-handler/about" = browsers;
        "x-scheme-handler/unknown" = browsers;

        # Directories
        "inode/directory" = fileManagers;
      };
    in
    null
    |> (_: {
      xdg.menus.enable = true;
      programs.gpu-screen-recorder.enable = true;
    })
    |> (
      attrs:
      attrs
      // {
        hjem.users.antonio = {
          xdg.config.files = {
            "xdg-terminals.list".text = "kitty.desktop";
          };
          xdg.mime-apps.default-applications = mimeTypes;
        };
      }
    );
}

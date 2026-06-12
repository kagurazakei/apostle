{ inputs, ... }:
{
  modules.programs.spicetify =
    {
      pkgs,
      ...
    }:
    let
      spicePkgs = inputs.spicetify.legacyPackages.${pkgs.system};
    in
    {
      hjem.extraModules = [ inputs.spicetify.hjemModules.default ];
      hj = {
        programs.spicetify = {
          enable = true;
          enabledExtensions = with spicePkgs.extensions; [
            powerBar
            fullAlbumDate
            fullAppDisplay
            listPlaylistsWithSong
            volumePercentage
            adblock
            hidePodcasts
            beautifulLyrics
            autoSkipExplicit
            shuffle # shuffle+ (special characters are sanitized out of extension names)
          ];
          enabledCustomApps = with spicePkgs.apps; [
            lyricsPlus
            newReleases
          ];
          theme = spicePkgs.themes.text;
          colorScheme = "RosePine";
        };
      };
    };
}

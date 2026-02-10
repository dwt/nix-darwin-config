{
  pkgs,
  pkgs-unstable,
  # pkgs-master,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # Tools and fun stuff
    yt-dlp # Download movies / audio from almost all websites
    ffmpeg # Video and audio converter and all around swiss army knife, required for yt-dlp to extract audio
    fortune # Show a random quote on login

    # Games
    # Doesn't like the lix build sandbox right now. :-(
    ut1999 # The original Unreal Tournament
    # mumble doesn't like the sandbox either right now :-(
    quake3arena-hires # The original deathmatch game
  ];
  nixpkgs.config.allowUnfreePackages = [
    "ut1999"
    "quake3-ioquake3-0-unstable-2025-05-15"
    "quake3arenadata"
    "quake3-pointrelease"
  ];
}

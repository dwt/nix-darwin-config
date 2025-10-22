{
  pkgs,
  pkgs-unstable,
  # pkgs-master,
  ...
}:
{
  environment.systemPackages = [
    # Tools and fun stuff
    pkgs.yt-dlp # Download movies / audio from almost all websites
    pkgs.ffmpeg # Video and audio converter and all around swiss army knife, required for yt-dlp to extract audio
    pkgs.fortune # Show a random quote on login

    # Games
    # Doesn't like the lix build sandbox right now. :-(
    # pkgs-unstable.ut1999 # The original Unreal Tournament
    # mumble doesn't like the sandbox either right now :-(
    pkgs-unstable.quake3arena-hires # The original deathmatch game
  ];
  nixpkgs.allowUnfreePackages = [
    "ut1999"
    "quake3-ioquake3-0-unstable-2025-05-15"
    "quake3arenadata"
    "quake3-pointrelease"
  ];
}

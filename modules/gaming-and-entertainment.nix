{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # Tools and fun stuff
    # Dependency Bug: https://github.com/NixOS/nixpkgs/pull/493943
    yt-dlp # Download movies / audio from almost all websites
    ffmpeg # Video and audio converter and all around swiss army knife, required for yt-dlp to extract audio
    fortune # Show a random quote on login

    # Games
    # Doesn't like the lix build sandbox right now. :-(
    ut1999 # The original Unreal Tournament
    quake3arena-hires # The original deathmatch game
  ];

  # needs patch in nix-darwin, so far only supported on nixos
  # system.extraDependencies = with pkgs; [
  #   ut1999.passthru.isos # cache for speedup
  # ];

  nixpkgs.config.allowUnfreePackages = [
    "ut1999"
    "quake3-ioquake3-0-unstable-2026-07-19"
    "quake3arenadata"
    "pak0.pk3"
    "quake3-pointrelease"
  ];
}

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
    # mumble doesn't like the sandbox either right now :-(
    quake3arena-hires # The original deathmatch game
  ];
  nixpkgs.config.allowUnfreePackages = [
    "ut1999"
    "quake3-ioquake3-0-unstable-2025-05-15"
    "quake3arenadata"
    "quake3-pointrelease"
    # duplicated here to reduce to single allowUnfreePackages until nix-darwin merges
    # https://github.com/nix-darwin/nix-darwin/pull/1742
    "textual-speedups" # required by mistral-vibe FIXME this should be in tools-and-projects-support.nix but that overrides this setting!
    "claude-code"
  ];
}

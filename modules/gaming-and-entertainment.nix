{
  pkgs,
  pkgs-unstable,
  # pkgs-master,
  ...
}:
{
  environment.systemPackages = [
    pkgs-unstable.ut1999 # The original Unreal Tournament
    pkgs.yt-dlp # Download movies / audio from almost all websites
  ];
  nixpkgs.allowUnfreePackages = [
    "ut1999"
  ];
}

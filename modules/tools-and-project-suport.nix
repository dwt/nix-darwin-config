{ pkgs, ... }:
{

  # List packages installed in system profile.
  # To search for new ones use https://search.nixos.org
  # To show installed tools use nix-tree
  environment.systemPackages = with pkgs; [
    direnv # .envrc automatic project configuration
    devenv # friendlier nix project configuration
    curlie # curl with httpie interface
  ];
}

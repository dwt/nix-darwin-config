{ pkgs, ... }:
{

  # List packages installed in system profile.
  # To search for new ones use https://search.nixos.org
  # To show installed tools use nix-tree
  environment.systemPackages = with pkgs; [
    direnv # .envrc automatic project configuration
    devenv # friendlier nix project configuration

    curlie # curl with httpie interface

    # TODO add fish configuration for these
    fzf # fuzzy finder with integration into many tools
    starship # cross shell prompt
    # not using this for all completions, but some are much better than what is built into fish
    carapace # multi shell completion library
  ];

  environment.variables = {
    EDITOR = "mate -w";
  };
}

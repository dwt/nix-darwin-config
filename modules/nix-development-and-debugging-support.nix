{ pkgs, ... }:
{
  # List packages installed in system profile.
  # To search for new ones use https://search.nixos.org
  # To show installed tools use nix-tree
  environment.systemPackages = with pkgs; [
    # TODO move these out into their own module
    ## nix development
    # https://github.com/Mic92/nixpkgs-review
    nixpkgs-review # check pull requests for nixpkgs
    nixfmt-rfc-style # format *.nix files
    nixd # langauge server
    nil # language server
    # https://github.com/maralorn/nix-output-monitor
    nix-output-monitor # visualize build output by piping stderr and stdout into `nom`
    # https://github.com/nix-community/nix-index
    nix-index # search which package provides a specific file
    nix-diff # compare nix derivations
    nix-tree # browse installed packages
  ];
}

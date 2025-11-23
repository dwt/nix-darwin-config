{ pkgs, pkgs-unstable, ... }:
let
  lix = pkgs.lixPackageSets.latest.lix;
in
{
  # Enhance nix default setup for flakes and lix
  nix.settings.experimental-features = [
    "lix-custom-sub-commands"
  ];

  # https://lix.systems/add-to-config/#advanced-change
  # see there for advanced nix -> lix overrides of custom packages
  # also supports: stable, latest, git
  nix.package = lix;

  environment.systemPackages = with pkgs.lixPackageSets.latest; [
    # https://github.com/Mic92/nixpkgs-review
    nixpkgs-review # check pull requests for nixpkgs -> moved to lix module as it needs to be patched to use lix natively
    (pkgs.nix-init.override {
      nix = lix;
    }) # create initial nix package from project url
    # nix-update # update nixpkgs packages
  ];
  programs.direnv.nix-direnv.package = pkgs.lixPackageSets.latest.nix-direnv;

  # I really want to find a way to include all packages that need overrides automatically, and this is not it.
  # https://git.lix.systems/lix-project/lix/issues/989
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     lix = pkgs-unstable.lixPackageSets.latest.lix;
  #     inherit (final.lixPackageSets.latest)
  #       nixpkgs-review
  #       nix-direnv
  #       # all of these do not trigger infinite recursion
  #       nix-eval-jobs
  #       nix-fast-build
  #       colmena
  #       ;
  #   })
  # ];
}

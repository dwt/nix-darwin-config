{ pkgs, ... }:
let
  packageSet = pkgs.lixPackageSets.latest;
  lix = packageSet.lix;
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

  environment.systemPackages = with packageSet; [
    # https://github.com/Mic92/nixpkgs-review
    # TODO use nixpkgs-reviewFull, though needs
    # https://github.com/NixOS/nixpkgs/pull/475129
    nixpkgs-review # check pull requests for nixpkgs
    # nix-review still warns about unknown config options -> still using the wrong nix?
    # Obsoleted by https://github.com/NixOS/nixpkgs/pull/466954
    (pkgs.nix-init.override {
      nix = lix;
    }) # create initial nix package from project url
    nix-update # update nixpkgs packages
  ];
  programs.direnv.nix-direnv.package = packageSet.nix-direnv;

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

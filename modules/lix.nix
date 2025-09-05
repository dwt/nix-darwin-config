{ pkgs, ... }:
{
  # https://lix.systems/add-to-config/#advanced-change
  # see there for advanced nix -> lix overrides of custom packages
  # also supports: stable, latest, git
  nixpkgs.overlays = [
    (final: prev: {
      inherit (final.lixPackageSets.stable)
        nixpkgs-review
        nix-direnv
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
    })
  ];

  nix.package = pkgs.lixPackageSets.stable.lix;
}

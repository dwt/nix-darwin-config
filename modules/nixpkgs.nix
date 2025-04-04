{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # TODO contribute allowUnfreePackages to nixpkgs
  options = with lib; {
    nixpkgs.allowUnfreePackages = mkOption {
      type = with types; listOf str;
      default = [ ];
      example = [ "ut1999" ];
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate =
      pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowUnfreePackages;

    # provide my custom nixpkgs versions
    _module.args =
      let
        # TODO contribute mkPkgs to nixpkgs.lib
        mkPkgs =
          customNixpkgsVersion:
          import customNixpkgsVersion {
            inherit (config.nixpkgs) config system;
          };
      in
      {
        # for the packages that are yet not part of the stable distribution
        pkgs-unstable = mkPkgs inputs.nixpkgs-unstable;
        # for when I am working on a package and want to test / use it after it was merged, but not yet to unstable
        # usually requires compilation, possibly of many dependencies!
        # I don't want to make this too easy, which is why the input is commented out too
        # pkgs-master = mkPkgs inputs.nixpkgs-master;
      };

  };
}

{
  inputs,
  lib,
  config,
  ...
}:
{
  # TODO contribute allowUnfreePackages to nixpkgs
  options = with lib; {
    nixpkgs.allowUnfreePackages = mkOption {
      type = with types; listOf str;
      default = [ ];
      example = [ "ut1999" ];
      description = ''
        Allows specific unfree packages to be used.

        This option overrides `nixpkgs.config.allowUnfreePredicate`with a function that permits the listed package names.

        Unlike `nixpkgs.config.allowUnfreePredicate`, this option merges additively, similar to `environment.systemPackages`.
        This enables defining allowed unfree packages in multiple modules, close to where they are used.

        This avoids the need to centralize all unfree package declarations or globally enable unfree packages via
        `nixpkgs.config.allowUnfree = true`.
      '';
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate = lib.mkIf (
      builtins.length config.nixpkgs.allowUnfreePackages > 0
    ) (pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowUnfreePackages);

    # provide my custom nixpkgs versions as optional module args
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
        # pkgs-local = mkPkgs inputs.nixpkgs-local;
      };

  };
}

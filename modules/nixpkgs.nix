{
  inputs,
  lib,
  config,
  ...
}:
{

  config = {

    # provide my custom nixpkgs versions as optional module args
    _module.args =
      let
        # TODO contribute mkPkgs to nixpkgs.lib
        mkPkgs =
          customNixpkgsVersion:
          import customNixpkgsVersion {
            inherit (config.nixpkgs) config system;
          };

        # Dynamically discover all nixpkgs-* inputs and create module arguments for them
        discoverPkgs =
          lib.attrNames inputs
          |> lib.filter (name: lib.hasPrefix "nixpkgs-" name)
          |> lib.map (name: {
            name = "pkgs-${lib.replaceStrings [ "nixpkgs-" ] [ "" ] name}";
            value = mkPkgs (inputs.${name});
          })
          |> lib.listToAttrs;
      in
      discoverPkgs;

  };

}

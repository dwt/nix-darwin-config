{ pkgs }:
{
  # TODO would like the tools in these scripts to come from this flake
  # so that you can use the flake form before the flake is installed, but don't have to use them afterwards
  readShellScripts =
    dir:
    let
      scriptFiles = pkgs.lib.filterAttrs (_: type: type == "regular") (builtins.readDir dir);
      script = name: pkgs.writeShellScript name (builtins.readFile "${dir}/${name}");
    in
    pkgs.lib.mapAttrs (name: _: {
      type = "app";
      program = "${script name}";
    }) scriptFiles;

}

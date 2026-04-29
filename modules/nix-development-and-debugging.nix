{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # fast local searches for nix packages by command
    inputs.nix-index-database.darwinModules.nix-index
  ];

  # prefix any tool call with , (or comma) to execute the correct nix package without installation
  programs.nix-index-database.comma.enable = true;

  # List packages installed in system profile.
  # To search for new ones use https://search.nixos.org
  # To show installed tools use nix-tree
  environment.systemPackages = with pkgs; [
    # TODO move these out into their own module
    ## nix development
    nixfmt # format *.nix files
    nixd # language server
    nil # language server
    # https://github.com/maralorn/nix-output-monitor
    nix-output-monitor # visualize build output by piping stderr and stdout into `nom`
    # https://github.com/nix-community/nix-index
    # installed via nix-index-database flake so it auto updates it's database
    # nix-index # search which package provides a specific file
    nix-search # fast `nix search` replacement
    nvd # show changed packages between two nix derivations
    nix-diff # compare nix derivations
    nix-tree # browse installed packages
    nix-inspect # browse nix derivation details
    nh # nicer frontend for search, build + diff and garbage collection $ nh search hello
    hydra-check # check build status of packages in hydra $ hydra-check hello --arch x86_64-darwin
    nurl # get the fetcher call with all arguments for a given url. Supports almost all fetchers.
  ];
}

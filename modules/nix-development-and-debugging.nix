{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nix-development-and-debugging;
in
{
  options.nix-development-and-debugging.enable = lib.mkEnableOption "nix-development-and-debugging";

  config = lib.mkIf cfg.enable {
    # List packages installed in system profile.
    # To search for new ones use https://search.nixos.org
    # To show installed tools use nix-tree
    environment.systemPackages = with pkgs; [
      # TODO move these out into their own module
      ## nix development
      # https://github.com/Mic92/nixpkgs-review
      #nixpkgs-review # check pull requests for nixpkgs -> moved to lix module as it needs to be patched to use lix natively
      nix-update # update nixpkgs packages
      nixfmt-rfc-style # format *.nix files
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
      nh # nicer frontend for search, build + diff and garbage collection $ nh search hello
      hydra-check # check build status of packages in hydra $ hydra-check hello --arch x86_64-darwin
      nix-init # create initial nix package from project url
    ];
  };
}

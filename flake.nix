{
  description = "mkk nix-darwin system flake";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgs-local.url = "/Users/dwt/Code/Projekte/nix/nixpkgs/"; # test changes before creating a pull request
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/pull/445223/head"; # test pull requests
    # nixpkgs-master.url = "github:NixOS/nixpkgs/master"; # if unstable is too old
    # nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11"; # should I ever want to go back to a stable branch
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-rosetta-builder.url = "github:cpick/nix-rosetta-builder";
    # when I want to test changes from me
    # nix-rosetta-builder.url = "github:dwt/nix-rosetta-builder/cleanup-on-disable";
    nix-rosetta-builder.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # mkk specific stuff
    mkk-vpn.url = "git+ssh://git@gitlab.com/bkkvbu/shared/openconnect-vpn-config";
    mkk-vpn.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nix-index-database,
      ...
    }:
    let
      system = "aarch64-darwin";
      darwin = nix-darwin.lib.darwinSystem {
        inherit system;
        # inputs are used for imports, so need to be passed via specialArgs to prevent infinite recursion
        specialArgs = { inherit inputs; };
        modules = [
          nix-index-database.darwinModules.nix-index # REFACT move, but don't know yet where
          ./configuration.nix
        ];
      };

      # take the instantiated nixpkgs out of darwin to prevent a double nixpkgs instantiation
      # this prevents a small speed hit, but most important it ensures that all nixpkgs instances use the same config
      pkgs = darwin.pkgs;
    in
    {
      lib = pkgs.callPackage ./lib { };
      apps.${system} = self.lib.readShellScripts ./bin;

      # Build darwin flake using: bin/switch
      darwinConfigurations."Sokrates" = darwin;

    };
}

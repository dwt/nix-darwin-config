{
  description = "mkk nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-2.tar.gz";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-rosetta-builder.url = "github:cpick/nix-rosetta-builder";
    nix-rosetta-builder.inputs.nixpkgs.follows = "nixpkgs";
    # home-manager.url = "github:nix-community/home-manager";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nix-index == nix-locate but with automatic database updates
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      lix-module,
      nix-darwin,
      # home-manager,
      nix-index-database,
      ...
    }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      lib = pkgs.callPackage ./lib { };
      apps.${system} = self.lib.readShellScripts ./bin;

      # Build darwin flake using:
      # $ bin/switch
      darwinConfigurations."Sokrates" = nix-darwin.lib.darwinSystem rec {
        inherit system;
        # inputs are used for imports, so need to be passed via specialArgs to prevent infinite recursion
        specialArgs = { inherit inputs; };
        modules = [
          lix-module.nixosModules.default
          nix-index-database.darwinModules.nix-index
          ./configuration.nix

          # {
          #   home-manager.useGlobalPkgs = true;
          #   home-manager.useUserPackages = true;
          #   home-manager.users.dwt = import ./home.nix;
          #   # Optionally, use home-manager.extraSpecialArgs to pass
          #   # arguments to home.nix
          # }
          # home-manager.darwinModules.home-manager
        ];
      };
    };
}

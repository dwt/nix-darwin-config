{
  description = "mkk nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    # nixpkgs-local.url = "/Users/dwt/Code/Projekte/nix/nixpkgs/";
    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.2-1.tar.gz";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-rosetta-builder.url = "github:cpick/nix-rosetta-builder";
    # when I want to test changes from me
    # nix-rosetta-builder.url = "github:dwt/nix-rosetta-builder/cleanup-on-disable";
    nix-rosetta-builder.inputs.nixpkgs.follows = "nixpkgs-unstable";
    # home-manager.url = "github:nix-community/home-manager";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nix-index == nix-locate but with automatic database updates
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # mkk specific stuff
    mkk-vpn.url = "git+ssh://git@gitlab.com/bkkvbu/shared/openconnect-vpn-config";
    mkk-vpn.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      lix-module,
      nix-darwin,
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
      darwinConfigurations."Sokrates" = nix-darwin.lib.darwinSystem {
        inherit system;
        # inputs are used for imports, so need to be passed via specialArgs to prevent infinite recursion
        specialArgs = { inherit inputs; };
        modules = [
          lix-module.nixosModules.default # REFACT move into nix-and-system-setup
          nix-index-database.darwinModules.nix-index # REFACT move, but don't know yet where
          # Work around nodejs compile problem
          # https://github.com/NixOS/nixpkgs/issues/402079
          # {
          #   nixpkgs.overlays = [
          #     (self: super: {
          #       nodejs = super.nodejs_22;
          #       nodejs-slim = super.nodejs-slim_22;

          #     })
          #   ];
          # }
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

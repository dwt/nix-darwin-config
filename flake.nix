{
  description = "mkk nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-rosetta-builder.url = "github:cpick/nix-rosetta-builder";
    nix-rosetta-builder.inputs.nixpkgs.follows = "nixpkgs";
    # home-manager.url = "github:nix-community/home-manager";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nix-index / nix-locate but with automatic database updates
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-master,
      lix-module,
      nix-darwin,
      nix-rosetta-builder,
      # home-manager,
      nix-index-database,
    }:
    let
      system = "aarch64-darwin";
      # REFACT consider to move out into lib?
      # Would like to ensure that all the dependeny tools come from this flake
      # while not cutting off access to system tools like launchctl
      readShellScripts =
        dir:
        let
          scriptFiles = nixpkgs.lib.filterAttrs (_: type: type == "regular") (builtins.readDir dir);
          script =
            name: nixpkgs.legacyPackages.${system}.writeShellScript name (builtins.readFile "${dir}/${name}");
        in
        nixpkgs.lib.mapAttrs (name: _: {
          type = "app";
          program = "${script name}";
        }) scriptFiles;
    in
    {
      apps.${system} = readShellScripts ./bin;

      # Build darwin flake using:
      # $ bin/switch
      darwinConfigurations."Sokrates" = nix-darwin.lib.darwinSystem rec {
        inherit system;
        specialArgs =
          let
            pkgs-unstable = import nixpkgs-unstable {
              config.allowUnfree = true;
              inherit system;
            };
            pkgs-master = import nixpkgs-master {
              config.allowUnfree = true;
              inherit system;
            };
          in
          {
            inherit inputs pkgs-unstable pkgs-master;
          };
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

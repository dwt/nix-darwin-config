{ inputs, ... }:
{
  # system.defaults.finder is deprecated, but no alternative is available yet
  # To keep it working, I need
  system = {
    primaryUser = "dwt";

    # Some finder settings
    defaults.finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv";
    };
  };

  # Workaround for error "Build user group has mismatching GID"
  ids.gids.nixbld = 30000;

  # Prevent warning because of https://github.com/LnL7/nix-darwin/issues/145
  nix = {
    channel.enable = false;

    # test python nixos-rebuild reimplementation
    # might be missing because I'm using the darwin branch?
    # system.rebuild.enableNg = true;

    # extra registry entries
    registry = {
      nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
      # I do not want to lock down master to the version built with this flake
      # as master is supposed to point to the latest and greatest
      nixpkgs-master.to = builtins.parseFlakeRef "github:NixOS/nixpkgs/master";
      # I don't want to point to a local path, until I find a better way, it stays like this
      # Consider: could I point to my github mirror? But I want to use it to point to things in development. :(
      # user   flake:nixpkgs-local path:/Users/dwt/Code/Projekte/nix/nixpkgs
    };

    # Enhance nix default setup for flakes and lix
    settings = {
      experimental-features = "nix-command flakes lix-custom-sub-commands pipe-operator";

      # Protect builds against accidentally pulling in dependencies from the host system
      # sandbox = true; # failed a rust build!

      # replace files with same content with hardlinks. Saves space
      auto-optimise-store = true;

      # FIXME how to set this from the configuration?
      # log-format = "multiline-with-logs";

      # enable cachix and lix substitutors
      substituters = [
        "https://cache.nixos.org"
        "https://cache.lix.systems"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      ];

      extra-nix-path = "nixpkgs=flake:nixpkgs";
      trusted-users = [
        "dwt"
      ];
      extra-platforms = [
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };

    # automatically prune no longer needed nix packages
    gc.automatic = true;
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}

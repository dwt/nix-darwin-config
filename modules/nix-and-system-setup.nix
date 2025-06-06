{ inputs, ... }:
{
  # system.defaults.finder is deprecated, but no alternative is available yet
  # To keep it working, I need
  system.primaryUser = "dwt";

  # Some finder settings
  system.defaults.finder = {
    AppleShowAllExtensions = true;
    FXPreferredViewStyle = "clmv";
  };

  # Workaround for error "Build user group has mismatching GID"
  ids.gids.nixbld = 30000;

  # Prevent warning because of https://github.com/LnL7/nix-darwin/issues/145
  nix.channel.enable = false;

  # test python nixos-rebuild reimplementation
  # might be missing becasue I'm using the darwin branch?
  # system.rebuild.enableNg = true;

  # Enhance nix default setup for flakes and lix
  nix.settings = {
    experimental-features = "nix-command flakes";

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

    # extra registry entries
    # not sure how to convert these to nix-darwin config
    # ❯ nix registry list
    # user   flake:nixpkgs-unstable github:NixOS/nixpkgs/nixpkgs-unstable
    # user   flake:nixpkgs-master github:NixOS/nixpkgs/master
    # user   flake:nixpkgs-local path:/Users/dwt/Code/Projekte/nix/nixpkgs

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
  nix.gc.automatic = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}

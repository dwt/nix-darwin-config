{ inputs, ... }:
{
  imports = [
    ./modules/mkk-kerberos-browsers.nix
    ./modules/sudo-with-biometrics.nix
    ./modules/nix-linux-rosetta-builder.nix
    ./modules/enable-fish-support.nix
    ./modules/nix-development-and-debugging-support.nix
    ./modules/nix-project-support.nix
  ];

  # Some finder settings
  system.defaults.finder = {
    AppleShowAllExtensions = true;
    FXPreferredViewStyle = "clmv";
  };

  # homebrew = {
  #   enable = true;
  # };

  # Prevent warning because of https://github.com/LnL7/nix-darwin/issues/145
  nix.channel.enable = false;

  # Enhance nix default setup for flakes and lix
  nix.settings = {
    experimental-features = "nix-command flakes";
    # TODO is this really neccessary? I probably just want the default.
    bash-prompt-prefix = "(nix:$name)\040";
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
      "root"
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

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}

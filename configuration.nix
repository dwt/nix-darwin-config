{ inputs, ... }:
{
  users.users.dwt = {
    name = "dwt";
    home = "/Users/dwt";
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
    ];

  # Some finder settings
  system.defaults = {
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
  };

  # homebrew = {
  #   enable = true;
  # };

  # Run the linux-builder as a background service
  # nix.linux-builder.enable = true;
  # find a way to make this not be permanently on
  # maybe https://github.com/cpick/nix-rosetta-builder
  # More details on configuring this:
  # https://nixcademy.com/posts/macos-linux-builder/
  # How this can be used to run nixpkgs test
  # https://nixcademy.com/posts/running-nixos-integration-tests-on-macos/

  # Enhance nix default setup for flakes and lix
  nix.settings = {
    experimental-features = "nix-command flakes";
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

  # Enable alternative shell support in nix-darwin.
  programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}

{ inputs, pkgs, ... }:
{
  imports = [
    ./modules/mkk-kerberos-browsers.nix
    ./modules/sudo-with-biometrics.nix
    ./modules/nix-linux-rosetta-builder.nix
  ];

  # Enable alternative shell support in nix-darwin.
  programs.fish.enable = true;
  programs.fish.vendor.completions.enable = true;
  programs.fish.vendor.config.enable = true;
  programs.fish.vendor.functions.enable = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # TODO move these out into their own module
    ## nix development
    # https://github.com/Mic92/nixpkgs-review
    nixpkgs-review # check pull requests
    nixfmt-rfc-style # formatter
    nixd # langauge server
    nil # language server
    # https://github.com/maralorn/nix-output-monitor
    nix-output-monitor # visualize build output by piping stderr and stdout into `nom`
    # https://github.com/nix-community/nix-index
    nix-index # search which package provides a specific file
    nix-diff # compare nix derivations

    # TODO move out into a local nix development module
    ## working with local nix projects
    direnv
    devenv
  ];

  # This only enables you to choose the new login shell in
  # -> SystemSettings -> Users & Groups -> Right click on users
  # "Advanced Settings" -> Change login shell
  environment.shells = [
    pkgs.fish
  ];

  # Some finder settings
  system.defaults.finder = {
    AppleShowAllExtensions = true;
    FXPreferredViewStyle = "clmv";
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

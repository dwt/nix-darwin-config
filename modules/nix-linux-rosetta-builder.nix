{
  inputs,
  ...
}:
{
  # https://github.com/cpick/nix-rosetta-builder
  # More details on configuring this:
  # https://nixcademy.com/posts/macos-linux-builder/
  # How this can be used to run nixpkgs test
  # https://nixcademy.com/posts/running-nixos-integration-tests-on-macos/

  imports = [
    # An existing Linux builder is needed to initially bootstrap `nix-rosetta-builder`.
    # If one isn't already available: comment out the `nix-rosetta-builder` module below,
    # uncomment this `linux-builder` module, and run `darwin-rebuild switch`:
    # { nix.linux-builder.enable = true; }
    # Then: uncomment `nix-rosetta-builder`, remove `linux-builder`, and `darwin-rebuild switch`
    # a second time. Subsequently, `nix-rosetta-builder` can rebuild itself.
    # show launchctl info
    # sudo launchctl list org.nixos.rosetta-builderd
    inputs.nix-rosetta-builder.darwinModules.default
  ];

  # I want this builder to not take up ram all the time.
  # This way it auto shuts down after 3h inactivity,
  # while the delay on first launch is almost neglible with about 5-10s.
  nix-rosetta-builder.onDemand = true;

}

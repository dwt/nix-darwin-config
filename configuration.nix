{ inputs, ... }:
{
  imports = [
    # mkk specifics
    ./modules/mkk-kerberos-browsers.nix

    # general system settings
    ./modules/nix-and-system-setup.nix
    ./modules/sudo-with-biometrics.nix
    ./modules/nix-linux-rosetta-builder.nix
    ./modules/enable-fish-support.nix
    ./modules/nix-development-and-debugging-support.nix

    # development workflow setup
    ./modules/tools-and-project-suport.nix
  ];


  # homebrew = {
  #   enable = true;
  # };

}

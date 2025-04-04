{ ... }:
{
  imports = [
    # mkk specifics
    ./modules/mkk-kerberos-browsers.nix

    # general system settings
    ./modules/nixpkgs.nix
    ./modules/nix-and-system-setup.nix
    ./modules/sudo-with-biometrics.nix
    ./modules/nix-linux-rosetta-builder.nix
    ./modules/enable-fish-support.nix
    ./modules/nix-development-and-debugging.nix

    # development workflow setup
    ./modules/tools-and-project-suport.nix

    # gaming & entertainment
    ./modules/gaming-and-entertainment.nix
  ];

  nix-development-and-debugging.enable = true;

  # homebrew = {
  #   enable = true;
  # };

}

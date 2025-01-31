{ pkgs, ... }:
{

  # Enable alternative shell support in nix-darwin.
  programs.fish.enable = true;
  programs.fish.vendor.completions.enable = true;
  programs.fish.vendor.config.enable = true;
  programs.fish.vendor.functions.enable = true;

  # This only enables you to choose the new login shell in
  # -> SystemSettings -> Users & Groups -> Right click on users
  # "Advanced Settings" -> Change login shell
  environment.shells = [
    pkgs.fish
  ];
}

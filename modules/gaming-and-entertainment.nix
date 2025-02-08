{
  pkgs-unstable,
  ...
}:
{
  environment.systemPackages = with pkgs-unstable; [
    # doesn't work yet, not sure why
    # https://github.com/LnL7/nix-darwin/issues/1328
    # Workaround:
    #  NIXPKGS_ALLOW_UNFREE=1 nix shell --impure nixpkgs-unstable#ut1999 --command open -a (NIXPKGS_ALLOW_UNFREE=1 nix eval --impure --raw nixpkgs-unstable#ut1999)/UnrealTournament.app
    ut1999
  ];
}

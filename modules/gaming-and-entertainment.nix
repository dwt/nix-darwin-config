{
  pkgs-unstable,
  pkgs-master,
  ...
}:
{
  environment.systemPackages = [
    # doesn't work yet, not sure why
    # https://github.com/LnL7/nix-darwin/issues/1328
    # Workaround:
    #  NIXPKGS_ALLOW_UNFREE=1 nix shell --impure nixpkgs-unstable#ut1999 --command open -a (NIXPKGS_ALLOW_UNFREE=1 nix eval --impure --raw nixpkgs-unstable#ut1999)/UnrealTournament.app
    # pkgs-unstable.ut1999
    # currently merging into unstable, so this is only for testing
    pkgs-master.ut1999
  ];
}

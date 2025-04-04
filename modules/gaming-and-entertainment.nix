{
  pkgs-unstable,
  # pkgs-master,
  ...
}:
{
  environment.systemPackages = [
    pkgs-unstable.ut1999
  ];
  nixpkgs.allowUnfreePackages = [
    "ut1999"
  ];
}

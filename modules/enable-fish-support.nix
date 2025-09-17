{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
{

  # Enable alternative shell support in nix-darwin.
  programs.fish = {
    enable = true;
    # nixpkgs-unstable is a bit behind and doesn't have fish 4 yet
    package = pkgs-unstable.fish; # fish 4
    vendor = {
      config.enable = true;
      completions.enable = true;
      functions.enable = true;
    };
  };

  # This only enables you to choose the new login shell in
  # -> SystemSettings -> Users & Groups -> Right click on users
  # "Advanced Settings" -> Change login shell
  environment.shells = [
    config.programs.fish.package
  ];

  # plugins should auto activate
  environment.systemPackages = [
    pkgs.fishPlugins.done # notify me when long running commands finish in the background
    # required by fishPlugins.done to post notifications
    pkgs.terminal-notifier
    pkgs.fishPlugins.autopair # auto insert matching parens and quotes
  ];

}

{
  config,
  pkgs,
  ...
}:
{

  # Enable alternative shell support in nix-darwin.
  programs.fish = {
    enable = true;
    package = pkgs.fish;
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

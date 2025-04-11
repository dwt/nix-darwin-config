{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    (inputs.mkk-vpn.packages.${pkgs.system}.default.overrideAttrs {
      dotenv = ./.env;
    })
  ];
}

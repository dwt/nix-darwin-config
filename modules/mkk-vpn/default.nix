{
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    (inputs.mkk-vpn.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs {
      dotenv = ./.env;
    })
  ];
}

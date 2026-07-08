# This is a testbed of how I can upstream this to nixpkgs
# Remove once https://nixpk.gs/pr-tracker.html?pr=533683 arrives in unstable
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.zmx;
  system = pkgs.stdenv.hostPlatform.system;
  zig2nix = inputs.zmx.inputs.zig2nix;
  zigEnv = zig2nix.outputs.zig-env.${system} {
    zig = zig2nix.outputs.packages.${system}.zig-0_15_2;
  };

  package =
    let
      sdkRoot = pkgs.apple-sdk.sdkroot;
      xcrunWrapper = pkgs.writeScriptBin "xcrun" ''
        #!/bin/sh
        echo "${sdkRoot}"
      '';
      xcodeselectWrapper = pkgs.writeScriptBin "xcode-select" ''
        #!/bin/sh
        echo "${sdkRoot}"
      '';

      unwrapped = zigEnv.package {
        src = inputs.zmx;
        zigBuildFlags = [ "-Doptimize=ReleaseSafe" ];
        glibc = null;
        musl = null;
        nativeBuildInputs = [
          pkgs.python3
          xcrunWrapper
          xcodeselectWrapper
        ];
        zigTarget =
          if pkgs.stdenv.hostPlatform.isAarch64 then "aarch64-macos.13.0" else "x86_64-macos.13.0";
      };
    in
    pkgs.runCommand unwrapped.name
      {
        nativeBuildInputs = [ pkgs.installShellFiles ];
        meta.mainProgram = "zmx";
      }
      ''
        mkdir -p $out/bin
        ln -s ${unwrapped}/bin/zmx $out/bin/zmx

        installShellCompletion --cmd zmx \
        --bash <($out/bin/zmx completions bash) \
        --zsh <($out/bin/zmx completions zsh) \
        --fish <($out/bin/zmx completions fish)
      '';
in
{
  options.programs.zmx.enable = lib.mkEnableOption "zmx";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      package
    ];
  };
}

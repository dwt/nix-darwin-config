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
        SDKROOT = sdkRoot;
        zigTarget =
          if pkgs.stdenv.hostPlatform.isAarch64 then "aarch64-macos.13.0" else "x86_64-macos.13.0";
        postPatch = ''
          python3 - <<'PY'
          from pathlib import Path

          path = Path("build.zig")
          text = path.read_text()
          text = text.replace(
              "        exe.linkLibC();",
              "        if (target.result.os.tag == .macos) exe.use_lld = false;\n        exe.linkLibC();",
              1,
          )
          text = text.replace(
              "        exe_check.linkLibC();",
              "        if (target.result.os.tag == .macos) exe_check.use_lld = false;\n        exe_check.linkLibC();",
              1,
          )
          text = text.replace(
              "            release_exe.linkLibC();",
              "            if (resolved.result.os.tag == .macos) release_exe.use_lld = false;\n            release_exe.linkLibC();",
              1,
          )
          path.write_text(text)
          PY
        '';
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

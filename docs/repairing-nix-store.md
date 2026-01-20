# Store balloons / broken paths

Check if garbage collection did not run to fruition

```sh
sudo -i nh clean all --keep 5 --keep-since 2w --verbose  --optimise
```

If it outputs stuff like:

```log
error: chmod 'iTerm2.app' in directory '/nix/store/lkfb8hfnbwz6ys9ki6x61ml2pf5x8n0c-iterm2-3.6.6/Applications': Operation not permitted
```

that path is likely broken.

Check store and all paths:

```sh
nix-store --verify --check-contents
```

If that doesn't work, I had to `nix store delete $path` and if that didn't work, manually `rm -rf` it, and then `nix store delete` again.

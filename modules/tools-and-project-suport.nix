# To clean out brew installed stuff
# brew leaves | xargs -n1 brew deps --installed --tree
# then bring over everything that can be installed here $ brew remove <pkg>
{
  pkgs,
  pkgs-unstable,
  pkgs-master,
  ...
}:
{
  # List packages installed in system profile.
  # To search for new ones use https://search.nixos.org
  # To show installed tools use nix-tree
  environment.systemPackages = with pkgs; [
    # direnv # .envrc automatic project configuration -> configured below
    devenv # friendlier nix project configuration
    pre-commit # git hooks

    fzf # fuzzy finder with integration into many tools
    # httpie # curl with a better interface
    curlie # curl with httpie interface
    zoxide # direct jumping to deep directories
    watch # run a command every second
    thefuck # correct previous command
    tealdeer # tldr shows command help summaries
    ripgrep # better grep
    pwgen # secure password generator
    pv # pipe progress viewer
    # moreutils # pee, sponge, ts, ... and more
    gnused # search and replace
    fd # find replacement
    eza # ls and tree replacement
    bat # cat with syntax highlighting and paging
    gnupg # asymetric encryption
    magic-wormhole # send files and folders securely without a server
    sad # search and replace (sed on steroids)

    # linters / language servers
    shellcheck # lint shell scripts
    shfmt # format bash scripts
    bash-language-server # d'oh
    pkgs-unstable.ruff # python linter
    ansible-lint
    pkgs-unstable.black # python formatter
    rubyPackages.solargraph # ruby language server
    yamllint
    pkgs-unstable.uv # faster pip

    # work with structured data
    jq # json query
    yq-go # jq for yaml
    jo # generate json from the shell
    jless # structured less for yaml/json

    # git stuff
    git # version control
    git-lfs # large files in external storage support
    lazygit # git TUI
    delta # git diff highlighter - side by side
    difftastic # git diff highlighter - syntax aware
    gh # github cli
    diffuse # diff3 gui tool

    # shell setup
    starship # cross shell prompt
    # not using this for all completions, but some are much better than what is built into fish
    # or fish does not have any. See for example kubectl and helm
    carapace # multi shell completion library

    # system monitoring and debugging
    pstree # shows tree of processes
    glances # better top
    # not in stable yet as of 2025-03-19
    pkgs-unstable.nvtopPackages.apple # gpu utilization top
    btop # better top with visualization
    # pkgs-unstable.macpm # apple power manager information
    ncdu # find large files
    mtr # traceroute and ping combined

    # sampler # Tool for shell commands execution, visualization and alerting
    # ttyplot # realtime plotting in terminal

    # working with kubernetes
    kubectl # kubernetes cli
    kubectx # switch between kubernetes contexts and namespaces
    pkgs-unstable.k9s # k8s tui
    kubernetes-helm # k8s package manager
    kubeseal # encrypt secrets for kubernetes
    krew # kubectl plugin manager
    kubeconform # manifest validator
    kubent # check for deprecated kubernetes apis
    pkgs-master.korrect # automatically use the correct kubectl version for the server

    # Ohter clouds
    hcloud
  ];

  # REFACT these should quite possibly go into home manager
  environment.variables = {
    EDITOR = "mate -w";
    LS_COLORS = ":no=00:rs=0:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.bat=01;32:*.BAT=01;32:*.btm=01;32:*.BTM=01;32:*.cmd=01;32:*.CMD=01;32:*.com=01;32:*.COM=01;32:*.dll=01;32:*.DLL=01;32:*.exe=01;32:*.EXE=01;32:*.arj=01;31:*.bz2=01;31:*.deb=01;31:*.gz=01;31:*.lzh=01;31:*.rpm=01;31:*.tar=01;31:*.taz=01;31:*.tb2=01;31:*.tbz2=01;31:*.tbz=01;31:*.tgz=01;31:*.tz2=01;31:*.z=01;31:*.Z=01;31:*.zip=01;31:*.ZIP=01;31:*.zoo=01;31:*.asf=01;35:*.ASF=01;35:*.avi=01;35:*.AVI=01;35:*.bmp=01;35:*.BMP=01;35:*.flac=01;35:*.FLAC=01;35:*.gif=01;35:*.GIF=01;35:*.jpg=01;35:*.JPG=01;35:*.jpeg=01;35:*.JPEG=01;35:*.m2a=01;35:*.M2a=01;35:*.m2v=01;35:*.M2V=01;35:*.mov=01;35:*.MOV=01;35:*.mp3=01;35:*.MP3=01;35:*.mpeg=01;35:*.MPEG=01;35:*.mpg=01;35:*.MPG=01;35:*.ogg=01;35:*.OGG=01;35:*.ppm=01;35:*.rm=01;35:*.RM=01;35:*.tga=01;35:*.TGA=01;35:*.tif=01;35:*.TIF=01;35:*.wav=01;35:*.WAV=01;35:*.wmv=01;35:*.WMV=01;35:*.xbm=01;35:*.xpm=01;35:";
  };

  # make *.localhost work, so each development project can have it's own domain and save it's passwords separately
  services.dnsmasq = {
    enable = true;
    addresses = {
      "localhost" = "127.0.0.1";
    };
  };

  # automatic project activation from .envrc file when entering a directory
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # faster flake activation times
    # silent = true; # stop output from direnv activation
    direnvrcExtra = ''
      # layout virtualenv $venv_relative_path
      layout_virtualenv() {
        local venv_path="$1"
        source ''${venv_path}/bin/activate
        # https://github.com/direnv/direnv/wiki/PS1
        unset PS1
      }

      # layout uv
      layout_uv() {
          if [[ -d ".venv" ]]; then
              VIRTUAL_ENV="$(pwd)/.venv"
          fi

          if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
              log_status "No virtual environment exists. Executing \`uv venv\` to create one."
              uv venv
              VIRTUAL_ENV="$(pwd)/.venv"
          fi

          PATH_add "$VIRTUAL_ENV/bin"
          export UV_ACTIVE=1  # or VENV_ACTIVE=1
          export VIRTUAL_ENV
      }
    '';
  };
}

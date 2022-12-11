{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePredicate = (_: true);

  home = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = "jrylander";
    homeDirectory = "/home/jrylander";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "22.11";

    packages = with pkgs; [
      bitwarden-cli
      chezmoi
      fd
      git
      htop
      signal-desktop

      entr
      just
      kubectl
      openssl
      openssl.dev
      pkg-config
      protobuf
      rustup
    ] ++ (if stdenv.isLinux then [
      chromium
      docker
      docker-compose
      gcc
      gnome3.gnome-tweaks
      jetbrains.idea-ultimate
      lens
      openconnect
      slack
      teams
      xsel
    ] else []);

    sessionVariables = {
      EDITOR = "nvim";
      GOOGLE_APPLICATION_CREDENTIALS="service-account-credentials.json";
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    bat.enable = true;

    go = {
      enable = true;
      goPath = "go";
    };

    tmux = {
      enable = true;
      shortcut = "w";
      keyMode = "vi";
      customPaneNavigationAndResize = true;
    };

    git = {
      enable = true;
      userEmail = "johan@rylander.cc";
      userName = "Johan Rylander";
      delta = {
        enable = true;
      };
      extraConfig = {
        core.excludesfile = "${config.home.homeDirectory}/.gitignore_global";
        url."git@git.svt.se:".insteadOf = "https://git.svt.se/";
        init.defaultBranch = "master";
        safe.directory = "/etc/nixos";
      };
    };

    zsh = {
      enable = true;
      defaultKeymap = "emacs";
      enableSyntaxHighlighting = true;
      enableAutosuggestions = true;
      history = {
        expireDuplicatesFirst = true;
        extended = true;
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "docker" "docker-compose" "kubectl" ];
      };
      initExtra = ''
        export GPG_TTY=$(tty)

        # NVM
        export NVM_DIR=$HOME/.local/share/nvm
        if [[ ! -e $NVM_DIR ]]; then
          git clone https://github.com/nvm-sh/nvm.git $NVM_DIR
        fi
        source $NVM_DIR/nvm.sh
        source $NVM_DIR/bash_completion

        # Rustup
        export CARGO_HOME=$HOME/.cargo
        if [[ -e $CARGO_HOME ]]; then
          export PATH=$CARGO_HOME/bin:$PATH
        fi

        export PATH=~/.local/bin:$PATH

        # The next line updates PATH for the Google Cloud SDK.
        if [ -f '/opt/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/google-cloud-sdk/path.zsh.inc'; fi

        # The next line enables shell command completion for gcloud.
        if [ -f '/opt/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/google-cloud-sdk/completion.zsh.inc'; fi
        
        if [ "$(hostname)" = "mcrylander" -o "$(hostname)" = "McRylander" ]
        then
          # brew
          export PATH=/opt/homebrew/bin:$PATH
          export PATH=/opt/homebrew/opt/libpq/bin:$PATH
        fi

        source ~/.zshrc-local || true
      '';
    };

    fzf = {
      enable = true;
    };

    neovim = {
      enable = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
        vim-nix
        fzf-vim
      ];

      extraConfig = ''
        syntax on
        set autochdir
        filetype plugin indent on
        set shiftwidth=2
        set expandtab
        let mapleader=' '
      '';
    };
  };
}

{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePredicate = (_: true);

  home = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    
    username = "jow2"; 
    homeDirectory = "/Users/jow2";

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
      cachix
      chezmoi
      entr
      fd
      jq
      k9s
      killall
      kn
      kubectl
      kubeseal
      lazygit
      ripgrep
    ];

    sessionVariables = {
      EDITOR = "${pkgs.neovim}/bin/nvim";
      GOOGLE_APPLICATION_CREDENTIALS = "service-account-credentials.json";
      PKG_CONFIG_PATH = "/home/jrylander/.nix-profile/lib/pkgconfig";
      GOROOT = "${pkgs.go}/share/go";
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    bat.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    tmux = {
      enable = true;
      shortcut = "w";
      keyMode = "vi";
      customPaneNavigationAndResize = true;
      escapeTime = 0;
      extraConfig = ''
        set-hook -g session-created 'rename-window history ; new-window ; rename-window profile ; new-window ; rename-window k8s ; new-window ; rename-window db ; new-window ; rename-window misc'

      '';
    };

    git = {
      enable = true;
      userEmail = "johan.rylander@svt.se";
      userName = "Johan Rylander";
      difftastic.enable = true;
      extraConfig = {
        core.excludesfile = "${config.home.homeDirectory}/.gitignore_global";
        url."git@git.svt.se:".insteadOf = "https://git.svt.se/";
        init.defaultBranch = "master";
        credential.helper = "store";
        pull.rebase  = "false";
      };
    };

    zsh = {
      enable = true;
      defaultKeymap = "emacs";
      enableSyntaxHighlighting = true;
      enableAutosuggestions = true;
      shellAliases = {
        dev = "k9s --context dev.aurora --namespace ds";
        app = "k9s --context app.aurora --namespace ds";
      };
      history = {
        expireDuplicatesFirst = true;
        extended = true;
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "docker" "docker-compose" "kubectl" ];
        theme = "robbyrussell";
      };
      initExtra = ''
        ### Fix slowness of pastes with zsh-syntax-highlighting.zsh
        pasteinit() {
          OLD_SELF_INSERT=''${''${(s.:.)widgets[self-insert]}[2,3]}
          zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
        }

        pastefinish() {
          zle -N self-insert $OLD_SELF_INSERT
        }
        zstyle :bracketed-paste-magic paste-init pasteinit
        zstyle :bracketed-paste-magic paste-finish pastefinish
        ### Fix slowness of pastes

        export GPG_TTY=$(tty)

        export PATH=~/.local/bin:$PATH

        # Rancher desktop
        export PATH=~/.rd/bin:$PATH

        # The next line updates PATH for the Google Cloud SDK.
        if [ -f '/opt/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/google-cloud-sdk/path.zsh.inc'; fi

        # The next line enables shell command completion for gcloud.
        if [ -f '/opt/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/google-cloud-sdk/completion.zsh.inc'; fi

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

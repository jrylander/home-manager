{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePredicate = (_: true);

  targets.genericLinux.enable = true;

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
      bind
      bitwarden-cli
      chezmoi
      docker
      docker-compose
      entr
      fd
      helm
      k9s
      killall
      kubectl
      lazygit
      ripgrep
      traceroute
    ];

    sessionVariables = {
      EDITOR = "${pkgs.neovim}/bin/nvim";
      NIX_PATH = "/home/jrylander/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels";
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
    };

    git = {
      enable = true;
      userEmail = "johan@rylander.cc";
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
      history = {
        expireDuplicatesFirst = true;
        extended = true;
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
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

        function kubectlgetall {
          for i in $(kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
            echo "Resource:" $$i
      
            if [ -z "$1" ]
            then
                kubectl get --ignore-not-found ''${i}
            else
                kubectl -n ''${1} get --ignore-not-found ''${i}
            fi
          done
        }

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

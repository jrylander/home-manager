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
      chezmoi
      fd
      htop
      entr
      helix
      jq
      just
      k9s
      kubectl
      postgresql
      protobuf
      rustup
      tmux
      wget
    ];

    sessionVariables = {
      EDITOR = "hx";
      GOOGLE_APPLICATION_CREDENTIALS = "service-account-credentials.json";
      PKG_CONFIG_PATH = "/home/jrylander/.nix-profile/lib/pkgconfig";
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    bat.enable = true;

    alacritty = {
      enable = true;
      settings = {
        import = [
          "~/.alacritty-colorscheme/themes/afterglow.yaml"
#          "~/.alacritty-colorscheme/themes/night_owlish_light.yaml"
        ];
        window.dimensions = {
          lines = 50;
          columns = 160;
        };
        font = {
          normal = {
            family = "Fira Code";
            style = "Regular";
          };

          bold = {
            family = "Fira Code";
            style = "Bold";
          };

          italic = {
            family = "Fira Code";
            style = "Italic";
          };

          bold_italic = {
            family = "Fira Code";
            style = "Bold Italic";
          };

          size = 18.0;
        };
      };
    };

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
        credential.helper = "store";
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
